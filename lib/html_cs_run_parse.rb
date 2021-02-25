require 'utility/parse_machine'

#this gem is specifically for running HTMLCS
class HTMLCS
  def self.run_html_cs(browser, file_name)
    browser.execute_script(File.read(File.expand_path("../HTMLCS.js", __FILE__)))
    browser.execute_script("HTMLCS_RUNNER.run('WCAG2AA')")
    output = browser.driver.manage.logs.get(:browser)
    parse = ParseMachine.new
    parse.htmlcs_parse(output, file_name)
  end
end
