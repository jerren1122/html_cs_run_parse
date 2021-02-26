$:.unshift File.dirname(__FILE__) + '/../struct_classes'
$:.unshift File.dirname(__FILE__) + '/../setup'
$:.unshift File.dirname(__FILE__) + '/../objects'
require 'score_collection'
require 'retrieval'
require 'page'
require 'row'
class Setup
  attr_accessor(:csv_collection, :url_collection, :image_collection, :app_name, :page_name_collection, :env, :score_collection)

  def initialize(file_location = "./data/input")
    rt = Retrieval.new(file_location)
    @csv_collection = rt.retrieve_csv_collection
    @url_collection = rt.retrieve_url_collection
    @image_collection = rt.retrieve_image_collection
    @app_name = rt.retrieve_app_name
    @page_name_collection = rt.retrieve_page_names
    @env = rt.retrieve_env
  end

  def main_setup(app, file_prefix = "./data/")
    app_initial_setup(app)
    pages = page_initial_setup
    app_additional_setup(app, pages)
    pages.each_with_index do |page, index|
      rows = row_initial_setup(index)
      row_additional_setup(rows, file_prefix + "scores.yaml")
      page_additional_setup(app, page, rows, file_prefix + "suppressed_rules.yaml")
    end
  end

  def row_initial_setup(index)
    output = []
    @csv_collection[index].each do |csv|
      @row = Row.new
      @row.set_value("error_warning", csv.error_warning)
      @row.set_value("guideline", csv.guideline)
      @row.set_value("error_description", csv.error_description)
      @row.set_value("html_path", csv.html_path)
      @row.set_value("content", csv.content)
      output.push(@row)
    end
    output
  end

  def app_initial_setup(app)
    app.set_value("application_name", app_name)
    app.set_value("env", env)
  end

  def page_initial_setup
    counter = 0
    output = page_name_collection.map do |page_name|
      page = Page.new
      page.set_value("page", page_name)
      page.set_value("url", url_collection[counter])
      page.set_value("image", image_collection[counter])
      counter += 1
      page
    end
    output
  end

  def row_additional_setup(rows, ddl = "./data/scores.yaml")
    @score_collection = ScoreCollection.new(ddl)
    rows.each do |row|
      row.calculate_score_value(@score_collection)
    end
  end

  def app_additional_setup(app, pages)
    app.set_value("pages", pages)
  end

  def page_additional_setup(app, page, rows, psr_location = "./data/suppressed_rules.yaml")
    page.set_value("rows", rows)
    score = page.calc_page_score
    page.set_value("score", score)
    page.set_value("app", app)
    page.access_spr(psr_location)
  end

end