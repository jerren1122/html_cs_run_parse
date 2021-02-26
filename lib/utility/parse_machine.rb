class ParseMachine
  require 'csv'

  def htmlcs_parse(violations, file_name)
    mod_output = iterate_violations(violations)
    write_csv(mod_output, file_name)

  end

  private

  def iterate_violations(violations)
    mod_output = []
    violations.each do |violation|
      if violation.message.include?('[HTMLCS]')
        splits = violation.message.split('|')
        error_or_warning = splits[0].split('[HTMLCS] ')[1]
        guideline = splits[1].gsub(',', '-')
        description = splits[4].gsub(',', '-')
        html_path = splits[5].gsub(',', '-')
        content = splits[2].gsub(',', '-')
        if error_or_warning != 'Notice'
          mod_output.push([error_or_warning, guideline, description, html_path, content])
        end
      end
    end
    mod_output
  end


  def write_csv(mod_output, file_name)
    CSV.open("#{file_name}.csv", "wb") do |csv|
      csv << ["type", "code", "message", "context", "selector"]
      mod_output.each { |mod_array|
        csv << mod_array
      }
    end
  end

end