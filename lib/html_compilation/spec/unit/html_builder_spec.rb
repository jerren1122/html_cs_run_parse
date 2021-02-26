require './classes/builders/html_builder'
require './classes/builders/app_html'
require './classes/builders/page_html'
require './classes/builders/row_html'
require './classes/objects/row'
require './classes/objects/app'
require './classes/objects/page'

describe 'html builder' do


  describe 'can build the application section/create the report' do
    describe 'graph/static sections' do
      it 'can populate the graph in the output for reference' do
        row1 = Row.new
        row1.send("guideline=", "global sample")
        row1.send("content=", "sample content")
        row2 = Row.new
        row2.send("guideline=", "global ample")
        row2.send("content=", "sample ontent")
        rows = [row1, row2]
        type_array = ['guideline', 'html_path', 'content', 'score', 'error_warning', 'instances']
        type_array.each_with_index { |type, index|
          if type == 'score' || type == 'instances'
            row1.set_value(type, index)
            row2.set_value(type, index)
          else
            row1.set_value(type, "sample" + index.to_s)
            row2.set_value(type, "sample" + index.to_s)
          end

        }
        page = Page.new
        page.set_value("image", "here")
        one = SuppressedPageRules.new('guideline 1', 'content 1')
        two = SuppressedPageRules.new('guideline 2', 'content 2')
        three = SuppressedPageRules.new('guideline 3', 'content 3')
        allow(page).to receive(:page_suppressed_rules).and_return [one, two, three]
        page.set_value("rows", rows)
        page.set_value("url", "www.wwe.wwf")
        page.set_value("score", 22)
        page.set_value("page", "sample page")

        page_1 = Page.new
        page_1.set_value("image", "here")
        one = SuppressedPageRules.new('guideline 1', 'content 1')
        two = SuppressedPageRules.new('guideline 2', 'content 2')
        three = SuppressedPageRules.new('guideline 3', 'content 3')
        allow(page_1).to receive(:page_suppressed_rules).and_return [one, two, three]
        page_1.set_value("rows", rows)
        page_1.set_value("url", "www.wwe.wwr")
        page_1.set_value("score", 24)
        page_1.set_value("page", "sample page 2")
        pages = [page, page_1]
        @app = Application.new
        @app.set_value('pages', pages)
        @app.set_value('application_name', 'sample name')
        @app.set_value('env', 'sample env')
        @ahtml = AppHTML.new(@app)
        # allow(@app).to receive(:calculate_app_score).and_return(22)
        # allow(@app).to receive(:calculate_total_errors).and_return(44)
        expect(@ahtml.build).to eq File.read('./spec/unit/data/expected/app.txt')

      end

    end
  end

  describe 'can build the page sections' do
    before do
      @page = Page.new
      @phtml = PageHTML.new(@page)
    end
    it 'builds the page sections with all optional content' do
      row1 = Row.new
      row1.send("guideline=", "global sample")
      row1.send("content=", "sample content")
      row2 = Row.new
      row2.send("guideline=", "global ample")
      row2.send("content=", "sample ontent")
      rows = [row1, row2]
      type_array = ['guideline', 'html_path', 'content', 'score', 'error_warning', 'instances']
      type_array.each_with_index { |type, index|
        if type == 'score' || type == 'instances'
          row1.set_value(type, index)
          row2.set_value(type, index)
        else
          row1.set_value(type, "sample" + index.to_s)
          row2.set_value(type, "sample" + index.to_s)
        end

      }
      page = Page.new
      page.set_value("image", "here")
      one = SuppressedPageRules.new('guideline 1', 'content 1')
      two = SuppressedPageRules.new('guideline 2', 'content 2')
      three = SuppressedPageRules.new('guideline 3', 'content 3')
      allow(page).to receive(:page_suppressed_rules).and_return [one, two, three]
      page.set_value("rows", rows)
      page.set_value("url", "www.wwe.wwf")
      page.set_value("score", 22)
      page.set_value("page", "sample page")
      lphtml = PageHTML.new(page)
      expect(lphtml.build).to eq File.read('./spec/unit/data/expected/page_optional.html')

    end

    it 'builds the page sections without optional content' do
      row1 = Row.new
      row1.send("guideline=", "global sample")
      row1.send("content=", "sample content")
      row2 = Row.new
      row2.send("guideline=", "global ample")
      row2.send("content=", "sample ontent")
      rows = [row1, row2]
      type_array = ['guideline', 'html_path', 'content', 'score', 'error_warning', 'instances']
      type_array.each_with_index { |type, index|
        if type == 'score' || type == 'instances'
          row1.set_value(type, index)
          row2.set_value(type, index)
        else
          row1.set_value(type, "sample" + index.to_s)
          row2.set_value(type, "sample" + index.to_s)
        end

      }
      page = Page.new
      page.set_value("rows", rows)
      page.set_value("score", 22)
      page.set_value("page", "sample page")
      lphtml = PageHTML.new(page)
      expect(lphtml.build).to eq File.read('./spec/unit/data/expected/page_no_optional.html')
    end

    it 'skips the html for the image if it does not exist' do
      expect(@phtml.gen_image_section).to eq ""
    end

    it 'generates the html for the image if it exists' do
      allow(@page).to receive(:image).and_return true
      allow(@page).to receive(:page).and_return "sample page"
      expect(@phtml.gen_image_section).to eq '<img src=".\files\sample page.png" class="content_image">'
    end

    it 'skips the html for the url if it does not exist' do
      expect(@phtml.gen_url_section).to eq ""
    end

    it 'generates the html for the url if it exists' do
      allow(@page).to receive(:url).and_return "www.google.com"
      expect(@phtml.gen_url_section).to eq "<h1 class=\"url-for-page\">URL: www.google.com</h1>"
    end

    it 'skips the html for the suppressed page errors if it does not exist' do
      expect(@phtml.gen_sup_rules_area).to eq ""
    end

    it 'generates the html for the suppressed page errors if it exists' do
      one = SuppressedPageRules.new('guideline 1', 'content 1')
      two = SuppressedPageRules.new('guideline 2', 'content 2')
      three = SuppressedPageRules.new('guideline 3', 'content 3')
      allow(@page).to receive(:page_suppressed_rules).and_return [one, two, three]
      expect(@phtml.gen_sup_rules_area).to eq '<table class="page_suppressed_rules_table"> <tbody class="page_suppressed_rules_table_body"> <tr> <th><strong>Suppressed Page Rules</strong></th> </tr> <tr><td><strong>Guideline: </strong>guideline 1<strong> Content: </strong>content 1</td></tr><tr><td><strong>Guideline: </strong>guideline 2<strong> Content: </strong>content 2</td></tr><tr><td><strong>Guideline: </strong>guideline 3<strong> Content: </strong>content 3</td></tr> </tbody> </table>'
    end


    it 'builds the header element for the rows dynamically based on the row elements' do
      allow(@row).to receive(:values).and_return(["error_warning", "guideline", "html_path", "content", "score"])
      allow(@phtml).to receive(:rows).and_return([@row])
      expect(@phtml.warning_header_gen).to eq "<th>error_warning</th><th>guideline</th><th>html_path</th><th>content</th><th>score</th><th>instances</th>"
    end


  end

  describe 'can build the row sections' do
    before do
      @row = Row.new
      @rhtml = RowHTML.new(@row)
    end
    it 'can successfully build the section' do
      allow(@row).to receive(:error_warning).and_return('this is an error or warning')
      allow(@row).to receive(:guideline).and_return('wcag 2.1')
      allow(@row).to receive(:html_path).and_return('this > that > the path')
      allow(@row).to receive(:content).and_return('<element content>')
      allow(@row).to receive(:score).and_return(22)
      allow(@row).to receive(:instances).and_return(11)
      allow(@row).to receive(:values).and_return(["error_warning", "guideline", "html_path", "content", "score", "instances"])
      expect(@rhtml.build).to eq File.read('./spec/unit/data/expected/row.html')
    end
  end

  describe 'general functionality' do
    it 'can convert values that cause issues with HTML' do
      test = HTML.new(@row)
      expect(test.htmlify("s>ring")).to eq "s&gt;ring"
      expect(test.htmlify("s<ring")).to eq "s&lt;ring"
      expect(test.htmlify("s&ring")).to eq "s&amp;ring"
      expect(test.htmlify("s&ri>n<g")).to eq "s&amp;ri&gt;n&lt;g"
    end

  end
end