Gem::Specification.new do |s|
  s.name        = 'html_cs_run_parse'
  s.version     = '0.1.0'
  s.summary     = "this allows for parsing and running of HTML Code Sniffer with Watir"
  s.description = ""
  s.authors     = ["Jerren Every"]
  s.email       = 'jerren1122@hotmail.com'
  s.files       = %w(lib/html_cs_run_parse.rb lib/HTMLCS.js lib/licence.txt lib/utility/parse_machine.rb lib/html_compilation/classes/builders/app_html.rb lib/html_compilation/classes/builders/graph.rb lib/html_compilation/classes/builders/html_builder.rb lib/html_compilation/classes/builders/page_html.rb lib/html_compilation/classes/builders/row_html.rb lib/html_compilation/classes/objects/app.rb lib/html_compilation/classes/objects/base_object.rb lib/html_compilation/classes/objects/page.rb lib/html_compilation/classes/objects/row.rb lib/html_compilation/classes/setup/conditioning.rb lib/html_compilation/classes/setup/output_generation.rb lib/html_compilation/classes/setup/retrieval.rb lib/html_compilation/classes/setup/setup.rb lib/html_compilation/classes/struct_classes/score_collection.rb lib/html_compilation/classes/struct_classes/suppressed_page_rules.rb lib/html_compilation/data/html_data/app_data.yaml lib/html_compilation/data/html_data/page_data.yaml lib/html_compilation/data/html_data/row_data.yaml lib/html_compilation/data/html_data/style_script.yaml lib/html_compilation/modules/image_interaction.rb lib/html_compilation/modules/yaml_interaction.rb lib/html_compilation/execution.rb)
  s.add_runtime_dependency 'rspec'
  s.add_runtime_dependency 'googlecharts'
  s.homepage    =
      'https://rubygems.org/gems/html_cs_run_parse'
  s.license       = 'MIT'
end