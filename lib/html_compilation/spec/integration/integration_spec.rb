require './classes/setup/setup'
require './classes/objects/app'
require './classes/objects/page'
require './classes/objects/row'
require './classes/setup/retrieval'
require './classes/setup/conditioning'
require './classes/setup/output_generation'
require './execution'

describe 'integration spec' do

  it 'can run the whole thing' do
    ofl = "./spec/unit/data/output/"
    Dir.glob(ofl + "*").each { |file|
      begin
        File.delete(file)
      rescue Errno::EACCES => e
      end }
    expect((Dir.glob(ofl + "*.html")).length).to eq 0
    ex = Execution.new
    ex.build(file_prefix = "./spec/unit/data/")
    expect((Dir.glob(ofl + "*.html")).length).to eq 1
  end

  describe 'input - Phase 0' do
    before do
      @setup = Setup.new("./spec/unit/data/input")
      @app = Application.new
      allow(@app).to receive(:application_name).and_return 'sample app'
              @setup.main_setup(@app, './spec/unit/data')
    end


    it 'can retrieve the necessary information from the passed files and convert them into accessible data e.g. application names, page names,  url, pa11y csv' do
      expect(@app.pages.length).to eq 2
      expect(@app.pages[0].rows.length).to eq 21
    end

    describe 'row level' do
      it 'retrieves or sets all values in the ATTR_ACCESSOR section, instances is set to 1 for the row level' do
        output = @app.pages[0].rows[0]
        collection = ["error_warning", "guideline", "error_description", "html_path", "content", "score"]
        expected_values = ["error", "\"WCAG2AA.Principle1.Guideline1_1.1_1_1.H37\"", "\"Img element missing an alt attribute. Use the alt attribute to specify a short text alternative.\"", "\"#omnibox-singlebox > div:nth-child(1) > div:nth-child(1) > button > img:nth-child(2)\"", "\"<img jstcache=\\\"94\\\" style=\\\"display:none\\\">\"", 1]
        expect(output.values).to eq collection
        collection.each_with_index do |content, index|
          expect(output.send(content)).to eq expected_values[index]
        end
      end
    end

    describe 'page level' do
      it 'retrieves all values in the ATTR_ACCESSOR section' do
        output = @app.pages[0]
        collection = ["page", "url", "image", "rows", "score", "app", "page_suppressed_rules"]
        expect(output.values).to eq collection
        collection.each_with_index do |content, index|
          expect(output.send(content)).not_to eq nil
        end
      end
    end

    describe 'app level' do
      it 'retrieves all values in the ATTR_ACCESSOR section' do
        collection = ["application_name", "env", "pages"]
        expect(@app.values).to eq collection
        collection.each_with_index do |content, index|
          expect(@app.send(content)).not_to eq nil
        end
      end
    end
  end


  describe 'post setup - phase 2 ' do
    before do
      @setup = Setup.new("./spec/unit/data/input")
      @app = Application.new
      allow(@app).to receive(:application_name).and_return 'sample app'
      @setup.main_setup(@app, './spec/unit/data')
      @conditioning = Conditioning.new()
    end
    describe 'page level' do

      it 'removes row elements that are suppressed' do
        expect(@app.pages[0].rows.length).to eq 21
        expect(@app.pages[1].rows.length).to eq 6
        @conditioning.main_condition(@app, "duplicates")
        expect(@app.pages[0].rows.length).to eq 19
        expect(@app.pages[1].rows.length).to eq 5
      end

      it 'removes row elements that are duplicates and sends updated duplicates to the App as part of the iteration of the creation of the pages after the rows have been completed' do
        expect(@app.pages[0].rows.length).to eq 21
        expect(@app.pages[1].rows.length).to eq 6
        @conditioning.main_condition(@app, "suppressed_rows")
        expect(@app.pages[0].rows.length).to eq 20
        expect(@app.pages[1].rows.length).to eq 3
      end

      it "ensures that row \"instances\" values are updated as part of the duplicate removal." do
        expect(@app.pages[0].rows.length).to eq 21
        expect(@app.pages[1].rows.length).to eq 6
        @conditioning.main_condition(@app)
        expect(@app.pages[0].rows.length).to eq 18
        expect(@app.pages[1].rows.length).to eq 3
        pages = [@app.pages[0], @app.pages[1]]
        count = 0
        pages.each do |page|
          page.rows.each do |row|
            count += row.instances.to_i
          end
        end
        expect(count).to eq 83
      end
      it "ensures that the each pages score is calculates after duplicate retrieval" do
        expect(@app.pages[0].score).to eq 21
        @conditioning.main_condition(@app)
        expect(@app.pages[0].score).to eq 18
      end
    end

    describe 'graph builder' do
      it 'generates the graph utilizing the app object' do
        expect(@app.graph).to eq nil
        @conditioning.main_condition(@app)
        expect(@app.graph.class).to eq Graph
      end
    end
  end


  describe 'output phase 3' do
    before do
      @setup = Setup.new("./spec/unit/data/input")
      @app = Application.new
      allow(@app).to receive(:application_name).and_return 'sample app'
      dl = './spec/unit/data/'
      @setup.main_setup(@app, dl)
      @conditioning = Conditioning.new()
      @conditioning.main_condition(@app, false, dl)
      @ofl = "./spec/unit/data/output/files/"
      @ofl1 = "./spec/unit/data/output/"
      Dir.glob(@ofl + "*").each { |file|
        begin
          File.delete(file)
        rescue Errno::EACCES => e
        end }

      Dir.glob(@ofl1 + "*").each { |file|
        begin
          File.delete(file)
        rescue Errno::EACCES => e
        end }
    end

    it 'generates the graph in the output folder' do
      expect((Dir.glob(@ofl + "chart.png")).length).to eq 0
      out = OutputGeneration.new(@app, @ofl)
      expect((Dir.glob(@ofl + "chart.png")).length).to eq 1

    end

    it 'generates the images in the output folder' do

      expect((Dir.glob(@ofl + "*.png")).length).to eq 0
      out = OutputGeneration.new(@app, @ofl)
      expect((Dir.glob(@ofl + "*.png")).length).to eq 3
    end

    it 'generates the html report in the output folder' do
      ofl = "./spec/unit/data/output/"
      expect((Dir.glob(ofl + "*.html")).length).to eq 0
      out = OutputGeneration.new(@app, @ofl)
      expect((Dir.glob(ofl + "*.html")).length).to eq 1
    end

  end
end