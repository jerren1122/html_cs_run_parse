$:.unshift File.dirname(__FILE__) + '/../builders'
require 'graph'

class Conditioning
  def main_condition(app, skip_value = false, ddl = "./data")
    app.pages.each do |page|
      unless skip_value == 'suppressed_rows'
        page.remove_suppressed_rows
      end
      unless skip_value == 'duplicates'
        app.remove_duplicates
      end
    end

    app.pages.each do |page|
      page.set_value('score', page.calc_page_score)
    end

    gp = Graph.new
    gp.generate_graph(app, ddl)
    app.set_value("graph", gp)
  end
end