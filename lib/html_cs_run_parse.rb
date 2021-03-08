require 'utility/parse_machine'
require 'html_compilation/execution'

#this gem is specifically for running HTMLCS
class HTMLCS
  def self.run_html_cs(browser, file_name)
    browser.execute_script(File.read(File.expand_path("../HTMLCS.js", __FILE__)))
    browser.execute_script("HTMLCS_RUNNER.run('WCAG2AA')")
    output = browser.driver.manage.logs.get(:browser)
    parse = ParseMachine.new
    parse.htmlcs_parse(output, file_name)
    browser.screenshot.save "#{file_name}.png"
    File.open(file_name + ".txt", 'w+') { |file|
      file.print(browser.url)
    }
  end

  def self.create_empty_directories(root_directory_name)
    html_input_location = root_directory_name + "/input"
    html_output_location = root_directory_name + "/output"
    html_file_location = root_directory_name + "/output/files"
    if Dir.exist?(html_input_location) == false
      Dir.mkdir(html_input_location)
      Dir.mkdir(html_output_location)
      Dir.mkdir(html_file_location)
    end
    [html_input_location, html_output_location, html_file_location].each { |location|
      Dir.glob("#{location}/**").each { |file|
        if file.include?('.txt') || file.include?('.png') || file.include?('.html') || file.include?('.csv')
          File.delete(file)
        end
      } }
  end

  def self.compile_html_cs(data_location)
    exec = Execution.new
    exec.build(data_location)
  end
end
