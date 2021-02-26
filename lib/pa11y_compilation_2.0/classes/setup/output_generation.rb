$:.unshift File.dirname(__FILE__) + '/../../modules'
$:.unshift File.dirname(__FILE__) + '/../builders'
require 'image_interaction'
require 'html_builder'
require 'page_html'
require 'app_html'
require 'row_html'
class OutputGeneration
  include ImageInteraction

  def initialize(app, ddl = "./data/output/files/")
    app.graph.populate_graph
    app.pages.each do |page|
      place_image_content(ddl + page.page, page.image)
    end
    app_html = AppHTML.new(app)
    html = app_html.build
    place_image_content(ddl.split("files/")[0] + "pa11y_" + app.application_name + '_' + app.env, html, ".html")
    #put html in the output folder need to remove files from ddl
  end
end