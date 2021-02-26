$:.unshift File.dirname(__FILE__) + '/../../modules'
require 'yaml_interaction'
require 'gchart'

class Graph
  attr_accessor(:chart)
  include YAMLInteraction
  attr_reader(:graph_length)


  def initialize
    @graph_length = 30
  end

  def generate_graph(app_object, ddl = "./data")
    gs = "/graph_scores.yaml"
    app = app_object.application_name.upcase.tr(' ', '_')
    score = app_object.calculate_app_score
    update_yaml(app, score, ddl + gs)
    values = array_slicer(read_yaml(ddl + gs, app).split(',').map(&:to_i))
    max = values.sort.last.to_i
    split = (max / 5).to_i
    value = 0
    string = '0|'
    values.length > graph_length ? end_range = graph_length : end_range = values.length
    4.times {value += split; string += value.to_s + '|'}
    self.send("chart=", Gchart.new({:type => 'bar',
                        :data => values,
                        :axis_with_labels => 'x,y',
                        :axis_labels => [(1..end_range).to_a.reverse, string],
                        :axis_range => [nil, [0, max]],
                        :title => "#{app.downcase.tr('_', ' ')} #{app_object.env}",
                        :legend => ['total score'],
                        :bg => {:color => 'white', :type => 'solid'},
                        :bar_colors => 'ADEFD1FF', :size => '1000x200',
                        :filename => "#{ddl}/output/files/chart.png"}))
  end

  def populate_graph
    chart.file
  end

  def array_slicer(values)
    if values.length > graph_length
      output = values[((values.length - 1) - (graph_length - 1))..(values.length - 1)]
    else
      output = values
    end
    output
  end

  def update_yaml(app, score, dl)
    app_up = app.upcase.tr(' ', '_')
    if !app_listed(app_up, dl)
      key_value_add(dl, app_up, score.to_s)
    else
      cur_val = read_yaml(dl, app_up)
      key_value_add(dl, app_up, cur_val + "," + score.to_s)
    end
  end

  def app_listed(app, dl)
    if read_yaml(dl, app) != nil
      true
    else
      false
    end
  end

end