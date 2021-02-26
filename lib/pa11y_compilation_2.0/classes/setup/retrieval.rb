$:.unshift File.dirname(__FILE__) + '/../../modules'
require 'image_interaction'
class Retrieval
  include ImageInteraction
  attr_accessor(:ddl)

  def initialize(ddl)
    @ddl = ddl
  end

  def retrieve_csv_collection
    output = []
    file_locations = return_all_files(ddl, 'csv')
    file_locations.each do |file_location|
      t_output = []
      File.open(file_location, 'r') { |file|
        content = file.read
        split = content.split("\n")
        split.delete_at(0)
        split.each do |row|
          components = row.split(',')
          csv_o = CSVObject.new(components[0].tr('"', ''), components[1], components[2], components[3], components[4])
          t_output.push(csv_o)
        end
        output.push(t_output)
      }
    end
    output
  end

  def retrieve_url_collection
    output = []
    file_locations = return_all_files(ddl, 'txt')
    file_locations.each do |file_location|
      File.open(file_location, 'r') { |file|
        output.push(file.read) }
    end
    output
  end

  def retrieve_image_collection
    output = []
    file_locations = return_all_files(ddl, 'png')
    file_locations.each do |file_location|
      File.open(file_location, 'r') { |file|
        output.push(retrieve_image_content(file)) }
    end
    output
  end

  def retrieve_app_name
    file = return_all_files(ddl, 'csv')[0]
    split = split_on_underscores(file)
    split[0]
  end

  def retrieve_page_names
    files = return_all_files(ddl, 'csv')
    output = []
    files.each do |file|
      output.push(split_on_underscores(file)[1])
    end
    output
  end

  def retrieve_env
    file = return_all_files(ddl, 'csv')[0]
    split = split_on_underscores(file)
    split[2].split('.')[0]
  end

  private

  def split_on_underscores(file)
    file.split('/').last.split('_')
  end

end

class CSVObject
  attr_accessor(:error_warning, :guideline, :error_description, :html_path, :content)

  def initialize(error_warning, guideline, error_description, content, html_path)
    @error_warning = error_warning
    @guideline = guideline
    @error_description = error_description
    @content = content
    @html_path = html_path
  end
end