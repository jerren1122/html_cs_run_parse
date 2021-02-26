require './classes/struct_classes/score_collection'
describe 'violation scores ability' do
  it 'can build a collection of violations that each have access to their score and guideline'  do
    test1 = ScoreCollection.new('./spec/unit/data/scores.yaml')
    expect(test1.guidelines.length).to eq 95
    expect(test1.guidelines[0].guideline).to eq 'Guideline1_1.1_1_1.H30.2'
    expect(test1.guidelines[0].score).to eq 1
    expect(test1.guidelines[0].categorization).to eq 'A'
  end
end