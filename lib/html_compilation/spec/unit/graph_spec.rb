require './classes/builders/graph.rb'
require './modules/yaml_interaction'
require './classes/objects/app'
include YAMLInteraction
describe 'graph generation' do
  before do
    @gp = Graph.new
  end

  it 'can generate a graph' do
    @app = Application.new
    allow(@app).to receive(:calculate_app_score).and_return(32)
    allow(@app).to receive(:application_name).and_return("sample app 1")
    allow(@app).to receive(:env).and_return("qa2")
    @gp.generate_graph(@app, "./spec/unit/data")
    expect(@gp.chart.title).to eq 'sample app 1 qa2'
    expect(@gp.chart.legend[0]).to eq 'total score'
    expect(@gp.chart.data.length).to eq 30
  end

  describe 'dealing with the graph yaml' do
    it 'can check if the app exists in the yaml'  do
      expect(@gp.app_listed("BANANA", "./spec/unit/data/graph_scores.yaml")).to eq false
      expect(@gp.app_listed("SAMPLE_EMPTY_APP", "./spec/unit/data/graph_scores.yaml")).to eq false
      expect(@gp.app_listed("SAMPLE_APP", "./spec/unit/data/graph_scores.yaml")).to eq true
    end

    it 'can add a new key to the yaml if necessary' do
      root = "adam"
      key = root.bytes.map{|char| (char + Random.rand(1..10)).chr}.join
      @gp.update_yaml(key, 22, "./spec/unit/data/graph_scores.yaml")
      expect(read_yaml("./spec/unit/data/graph_scores.yaml", key.upcase.tr(' ', '_'))).to eq '22'
    end

    it 'can add new values to any key' do
      key = "sample app 1"
      mkey = key.upcase.tr(' ', '_')
      dl = "./spec/unit/data/graph_scores.yaml"
      values = read_yaml(dl, mkey)
      score = 22
      @gp.update_yaml(key, score, dl)
      expect(read_yaml(dl, mkey)).to eq values + ',' + score.to_s
    end

  end

    it 'pulls data maxed for the last 30 executions' do
      values = (1..35).to_a
      output = @gp.array_slicer(values)
      expect((output).length).to eq 30
      expect(output[0]).to eq 6
      expect(output[output.length - 1]).to eq 35
    end
end