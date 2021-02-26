$:.unshift File.dirname(__FILE__) + '/../../modules'
require 'yaml_interaction'
class ScoreCollection
  include YAMLInteraction
  attr_accessor(:guidelines)

  def initialize(ddl="./data/scores.yaml")
    send("guidelines=", get_guidelines(ddl))
  end

  def get_guidelines(ddl)
    output = []
    collections = read_yaml(ddl, "GUIDELINES")
    collections.each do |key, value|
      score = read_yaml(ddl, "SCORES")[key]
      value.each do |guideline|
        temp = ScoreElement.new(key, score, guideline)
        output.push(temp)
      end
    end
    output
  end
end

class ScoreElement
  attr_accessor(:guideline, :score, :categorization)

  def initialize(categorization, score, guideline)
    send("guideline=", guideline)
    send("categorization=", categorization)
    send("score=", score)
  end
end