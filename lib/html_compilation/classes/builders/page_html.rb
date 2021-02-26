$:.unshift File.dirname(__FILE__)
require 'row_html'
class PageHTML < HTML
  attr_accessor(:rows)
  def initialize(object)
    self.send("data_location=", File.expand_path("../../../data/html_data/page_data.yaml", __FILE__))
    self.send("rows=", object.rows)
    super(object)
  end

  def build
    #populate warning headers
    row_headers = warning_header_gen

    #populate list of warning from the row
    row_content = rows.map do |row|
      rhtml = RowHTML.new(row)
      rhtml.build
    end.join

    #populate the warning list area as a whole.
    warn_list = read_yaml(data_location, "WARNING_LIST_AREA")
    warn_list.gsub!('header_sample', row_headers)
    warn_list.gsub!('rows_sample', row_content)

    #generate the page info section
    page_info = read_yaml(data_location, "PAGE_INFO")
    url = gen_url_section
    image = gen_image_section
    sup_rule_area = gen_sup_rules_area
    page_info.gsub!('sample', url + image + sup_rule_area)

    #generate the content section which combines page_info and warn_list
    content = read_yaml(data_location, "CONTENT")
    content.gsub!('sample', page_info + warn_list)

    #generate the collapsible_button_section
    cb = read_yaml(data_location, "COLLAPSIBLE_BUTTON")
    cb.gsub!("Sample Page Name", object.page)
    cb.gsub!("sample total number of errors", object.rows.length.to_s)
    cb.gsub!("sample page score", object.score.to_s)

    #generate the whole page content section
    cls = read_yaml(data_location, "COLLAPSIBLE_LIST_SECTION")
    cls.gsub!("sample", cb + content)

    cls
  end

  def warning_header_gen
    headers = read_yaml(data_location, "WARNING_LIST_HEADERS")
    output = rows[0].values.map do |key|
      headers.gsub("sample", key)
    end
    output.push(headers.gsub("sample", "instances"))
    output.join.to_s
  end

  def gen_image_section
    if object.image != nil
      html = read_yaml(data_location, "PAGE_IMAGE")
      output = html.gsub("sample", htmlify(object.page))
    else
      output = ""
    end
    output
  end

  def gen_url_section
    if object.url != nil
      html = read_yaml(data_location, "PAGE_URL")
      output = html.gsub("sample", htmlify(object.url))
    else
      output = ""
    end
    output
  end

  def gen_sup_rules_area
    if object.page_suppressed_rules != nil
      table_value = read_yaml(data_location, "PAGE_SUPPRESSED_RULES_TABLE_VALUES")
      psr = object.page_suppressed_rules.map do |rule|
        table_value.gsub("sample","<strong>Guideline: </strong>" + htmlify(rule.guideline) + "<strong> Content: </strong>" + htmlify(rule.content))
      end
      output = read_yaml(data_location, "PAGE_SUPPRESSED_RULES_AREA").gsub("sample", psr.join.to_s)
    else
      output = ""
    end
    output
  end
end
