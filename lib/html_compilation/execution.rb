$:.unshift File.dirname(__FILE__)
require 'classes/setup/setup.rb'
require 'classes/objects/app'
require 'classes/setup/conditioning.rb'
require 'classes/setup/output_generation.rb'
class Execution
  def build(file_prefix = "./data/")
    app = Application.new

    setup = Setup.new(file_prefix + "/input")
    setup.main_setup(app, file_prefix)

    conditioning = Conditioning.new
    conditioning.main_condition(app, skip_value = false, ddl = file_prefix)

    out = OutputGeneration.new(app, file_prefix + "/output/files/")
  end
end