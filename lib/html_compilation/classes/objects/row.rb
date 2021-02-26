$:.unshift File.dirname(__FILE__)
require 'base_object'

class Row < BaseObject
  def initialize
    super
    send("instances=", 1)
  end
  attr_accessor(:error_warning, :guideline, :error_description, :html_path, :content, :score, :values, :instances)

  def calculate_score_value(collection_element)
    dv = 1
    collection_element.guidelines.each do |sg|
      if guideline.include?(sg.guideline)
        dv = sg.score
      end
    end
    set_value("score", dv)
  end

end

