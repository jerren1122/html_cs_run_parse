require './classes/objects/row'
require './classes/struct_classes/score_collection'
describe 'row functionality' do
  before do
    @test = Row.new
  end

  it 'can store and retrieve all necessary elements for the row' do
    type_array = ['guideline', 'html_path', 'content', 'score', 'error_warning']
    type_array.each { |type|
      @test.set_value(type, "sample")
      expect(@test.send(type)).to eq("sample")
    }
  end

  it 'knows the corresponding headers for each row element this would be the method name' do
    @test.set_value('guideline', "sample")
    expect(@test.send("values")).to eq(['guideline'])
    @test.set_value('html_path', "sample")
    expect(@test.send("values")).to eq(['guideline', 'html_path'])
  end


  describe 'score calculation' do
    it 'can retrieve the score values' do
      @test.set_value('guideline', "aabbGuideline1_4.1_4_3.G145aabb")
      scores = ScoreCollection.new('./spec/unit/data/scores.yaml')
      @test.calculate_score_value(scores)
      expect(@test.score).to eq 2
    end

    it 'provides 0 as the default score value for a row' do
      @test.set_value('guideline', "Guideline1_1_4_3.G145")
      scores = ScoreCollection.new('./spec/unit/data/scores.yaml')
      @test.calculate_score_value(scores)
      expect(@test.score).to eq 1
    end

  end
end


