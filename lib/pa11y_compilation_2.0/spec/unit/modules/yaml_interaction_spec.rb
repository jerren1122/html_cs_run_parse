require './modules/yaml_interaction'
include YAMLInteraction
describe 'yaml interaction' do
  it 'can retrieve data from a YAML File for a specific value' do
    expect(read_yaml("./spec/unit/data/suppressed_rules.yaml", "GLOBAL_LEVEL").keys).to eq ["GLOBAL"]
  end

  it 'can add new key value pairs' do
    root = "banana"
    key = root.bytes.map{|char| (char + Random.rand(1..10)).chr}.join
    value = "1,2,2,3"
    key_value_add("./spec/unit/data/graph_scores.yaml", key, value)
    expect(read_yaml("./spec/unit/data/graph_scores.yaml", key.upcase.tr(' ', '_'))).to eq '1,2,2,3'
  end

end