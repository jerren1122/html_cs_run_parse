$:.unshift File.dirname(__FILE__)
require 'page_html'
class AppHTML < HTML
  attr_accessor(:pages)
  def initialize(object)
    self.send("data_location=", './data/html_data/app_data.yaml')
    self.send("pages=", object.pages)
    super(object)
  end

  def build
    #build the adr section
    adr = read_yaml(data_location, "APPLICATION_DATA_ROW")
    score = object.calculate_app_score
    errors = object.calculate_total_errors
    page_number = object.pages.length
    adrs = [score, errors, page_number].map do |section|
      adr.gsub('sample', section.to_s)
    end.join

    #build the ADS Section
    ads = read_yaml(data_location, "APPLICATION_DATA_SECTION")
    ads.gsub!("sample", adrs)

    #build the AOTS Section
    aots = read_yaml(data_location, "APPLICATION_OVERVIEW_TABLE_SECTION")
    aots.gsub!("sample", ads)

    #build the CI section
    ci = read_yaml(data_location, "CHART_IMAGE")

    #build the AOS section
    aos = read_yaml(data_location, "APPLICATION_OVERVIEW_SECTION")
    aos.gsub!("sample", aots + ci)

    #building the page sections
    page_rows = object.pages.map do |page|
      PageHTML.new(page).build
    end.join

    #build the HB section
    hb = read_yaml(data_location, "HTML_BODY")
    hb.gsub!("sample", aos + page_rows)

    #build the app section
    ats = read_yaml(data_location, "APPLICATION_TITLE_SECTION")
    ats.gsub!('sample', object.application_name + " utilizing: " + object.env)

    #build the html section
    html = read_yaml(data_location, "HTML")
    html.gsub!("sample", ats + hb)

    #add the style sheet to the beginning
    ssloc = "./data/html_data/style_script.yaml"
    style = read_yaml(ssloc, "STYLE")
    html = style + html

    #add the script to the end
    script = read_yaml(ssloc, "SCRIPT")
    html = html + script
  end
end