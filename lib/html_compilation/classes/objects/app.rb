$:.unshift File.dirname(__FILE__)
require 'base_object'
class Application < BaseObject
  attr_accessor(:values, :application_name, :pages, :graph, :env)

  def calculate_app_score
    counter = 0
    pages.each do |page|
      counter += page.score
    end
    counter
  end

  def calculate_total_errors
    counter = 0
    pages.each do |page|
      counter += page.rows.length
    end
    counter
  end

  def remove_duplicates
    pages.reverse.each do |page|
      page.remove_duplicates(self)
    end
  end

end