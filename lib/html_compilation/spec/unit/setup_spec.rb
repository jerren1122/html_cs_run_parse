require './classes/setup/setup'
require './classes/objects/app'
require './classes/objects/page'
require './classes/objects/row'
require './classes/setup/retrieval'

describe 'setup of all classes and objects with data' do
  it 'can run the overall setup' do
    @setup = Setup.new("./spec/unit/data/input")
    app = Application.new
    allow(app).to receive(:application_name).and_return 'sample app'
    @setup.main_setup(app, './spec/unit/data/')
    expect(app.pages.length).to eq 2
    expect(app.pages[0].rows.length).to eq 21
  end
  describe 'row setup' do
    describe 'initialization' do
      describe 'individual components' do
        before do
          @ret = Retrieval.new('./spec/unit/data/input')
        end
        it 'retrieves the csv files as a collection' do
          expect(@ret.retrieve_csv_collection.length).to eq 2

        end

        it 'retrieves the url files as a collection' do
          expect(@ret.retrieve_url_collection.length).to eq 2
        end

        it 'retrieves the images as a collection' do
          expect(@ret.retrieve_image_collection.length).to eq 2
        end

        it 'retrieves the app name' do
          expect(@ret.retrieve_app_name).to eq 'google'
        end

        it 'retrieves the page names as a collection' do
          expect(@ret.retrieve_page_names).to eq ['maps', 'search']
        end

        it 'retrieves the env' do
          expect(@ret.retrieve_env).to eq 'qa1'
        end
      end
    end
    describe 'iterates through all rows' do
      describe 'row initial setup' do
        before do
          @setup = Setup.new("./spec/unit/data/input")
          @output = @setup.row_initial_setup(1)
        end

        it 'stores all of the rows' do
          expect(@output.length).to eq 6
        end

        it "returns an array of Row objects" do
          expect(@output[0].class).to eq Row
        end

        it 'can store the error_warning' do
          expect(@output[0].error_warning).to eq "error"
        end

        it 'can store the error_description' do
          expect(@output[0].error_description).to eq "\"Presentational markup used that has become obsolete in HTML5.\""
        end

        it 'can store the guideline' do
          expect(@output[0].guideline).to eq "\"WCAG2AA.Principle1.Guideline1_3.1_3_1.H49.Center\""
        end

        it 'can store the HTML path' do
          expect(@output[0].html_path).to eq "\"html > body > center\""
        end

        it 'can store the content' do
          expect(@output[0].content).to eq "\"<center><br clear=\\\"all\\\" id=\\\"lgpd\\\"><div ...</center>\""
        end


      end

      describe 'row follow up setup' do
        before do
          @setup1 = Setup.new("./spec/unit/data/input")
          @rows = @setup1.row_initial_setup(1)
          @setup1.row_additional_setup(@rows, "./spec/unit/data/scores.yaml")
        end

        it 'can calculate the score' do
          expect(@rows[1].score).to eq 1
        end

        it 'records all stored accessors with values' do
          expect(@rows[0].values).to eq ["error_warning", "guideline", "error_description", "html_path", "content", "score"]
        end

      end
    end
  end

  describe 'page setup' do
    before do
      @setup = Setup.new("./spec/unit/data/input")
    end
    describe 'iterates through all pages' do
      describe 'initial page setup' do
        before do
          @pages = @setup.page_initial_setup
        end
        it 'can store the page name in the page element' do
          expect(@pages[0].page).to eq 'maps'
          expect(@pages[1].page).to eq 'search'
        end

        it 'can store the url' do
          expect(@pages[0].url).to eq 'www.google.com/maps'
          expect(@pages[1].url).to eq 'www.google.com/search'
        end

        it 'can store the image' do
          expect(@pages[0].image.length).to eq 620912
          expect(@pages[1].image.length).to eq 6777226
        end
      end

      describe 'follow up page setup' do
        before do
          @setup = Setup.new("./spec/unit/data/input")
          @app = Application.new
          @app.set_value("application_name", "sample app")
          @rows = @setup.row_initial_setup(0)
          @setup.row_additional_setup(@rows,"./spec/unit/data/scores.yaml")
          @pages = @setup.page_initial_setup
        end
        it 'can store an array of all of the rows' do
          @setup.page_additional_setup(@app, @pages[0], @rows)
          expect(@pages[0].rows).to eq @rows
        end

        it 'can calculate the page score' do
          @setup.page_additional_setup(@app, @pages[0], @rows)
          expect(@pages[0].score).to eq 21
        end

        it 'can store the generated instance of the app class in the app element' do
          @setup.page_additional_setup(@app, @pages[0], @rows)
          expect(@pages[0].app).to eq @app
        end

        it 'can store the page_suppressed_rows' do
          @setup.page_additional_setup(@app, @pages[0], @rows, "./spec/unit/data/suppressed_rules.yaml")
          expect(@pages[0].page_suppressed_rules[0].class).to eq SuppressedPageRules
          expect(@pages[0].page_suppressed_rules.length).to eq 3
        end

        it 'records all stored accessors with values' do
          @setup.page_additional_setup(@app, @pages[0], @rows, "./spec/unit/data/suppressed_rules.yaml")
          expect(@pages[0].values).to eq ["page", "url", "image", "rows", "score", "app", "page_suppressed_rules"]
        end
      end
    end
  end

  describe 'app setup' do
    before do
      @setup = Setup.new("./spec/unit/data/input")
      @app = Application.new
    end
    describe 'initial app setup' do
      it 'can store the application name' do
        @setup.app_initial_setup(@app)
        expect(@app.application_name).to eq 'google'
      end

      it 'can store the env' do
        @setup.app_initial_setup(@app)
        expect(@app.env).to eq 'qa1'
      end
    end

    describe 'follow-up app setup' do
      it 'can store an array of all of the pages' do
        @pages = @setup.page_initial_setup
        @setup.app_additional_setup(@app, @pages)
        expect(@app.pages.length).to eq 2
      end

      it 'records all stored accessors with values' do
        @setup.app_initial_setup(@app)
        @pages = @setup.page_initial_setup
        @setup.app_additional_setup(@app, @pages)
        expect(@app.values).to eq ["application_name", "env", "pages"]
      end
    end


  end
end