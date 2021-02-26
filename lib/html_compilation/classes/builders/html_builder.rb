$:.unshift File.dirname(__FILE__) + '/../../modules'
require 'yaml_interaction'

class HTML
  attr_accessor(:data_location, :object)
  include YAMLInteraction

  def initialize(object)
    @object = object
  end

  def htmlify(string)
    subs = {"&" => "&amp;", '<' => "&lt;", '>' => "&gt;"}
    subs.each do |key, value|
      if string.to_s.include?(key)
        begin
          string.gsub!(key, value)
        rescue NoMethodError => e
          print e.message
        end
      end
    end
    string
  end
end 


