require './classes/objects/page'
require './classes/objects/app'
require './classes/objects/row'

describe 'page functionality' do

  describe 'general functionality' do
    it 'can store and retrieve all necessary elements for the page' do
      test = Page.new
      type_array = ['page', 'url', 'image', 'rows']
      type_array.each { |type|
        test.set_value(type, "sample")
        expect(test.send(type)).to eq("sample")
      }
      expect(test.values).to eq type_array
    end
  end

  describe 'rule suppression' do

    it 'can store and return the page suppressed rules' do
      test1 = Page.new
      app = Application.new
      app.set_value("application_name", "sample app")
      test1.set_value('app', app)
      test1.set_value('page', "sample page1")
      test1.access_spr("./spec/unit/data/suppressed_rules.yaml")
      expect(test1.page_suppressed_rules.length).to eq 4
    end

    it 'can remove page suppressed rows by the rule' do
      test2 = Page.new
      test2.send('page_suppressed_rules=', [SuppressedPageRules.new("global sample", "sample content"), SuppressedPageRules.new("global sample 1", "sample_content 1")])
      row1 = Row.new
      row1.send("guideline=", "global sample")
      row1.send("content=", "sample content")
      row2 = Row.new
      row2.send("guideline=", "global ample")
      row2.send("content=", "sample ontent")
      test2.send('rows=', [row1, row2])
      test2.remove_suppressed_rows
      expect(test2.rows.length).to eq 1
    end

  end

  describe 'duplicate removal' do
    it 'can remove duplicates from the page based on what is returned from the App' do
      app1 = Application.new
      page1 = Page.new
      page2 = Page.new
      app1.send("pages=", [page1, page2])
      test3 = Page.new
      app_row_1 = Row.new
      app_row_1.send("guideline=", "global sample")
      app_row_1.send("content=", "sample content")
      app_row_1.send("instances=", "2")
      app_row_2 = Row.new
      app_row_2.send("guideline=", "lobal sample")
      app_row_2.send("content=", "ample content")
      app_row_2.send("instances=", "2")
      row1 = Row.new
      row1.send("guideline=", "global sample")
      row1.send("content=", "sample content")
      row2 = Row.new
      row2.send("guideline=", "global ample")
      row2.send("content=", "sample ontent")
      page1.send("rows=", [app_row_1])
      page2.send("rows=", [app_row_2])
      test3.send("rows=", [row1, row2])
      test3.remove_duplicate_rows_external(app1, test3)
      expect(test3.rows.length).to eq 1
      expect(app_row_1.instances.to_i).to eq 3
    end

    it 'can remove duplicates that occur within the same page 1 duplicate' do
      test4 = Page.new
      row1 = Row.new
      app_rows = []
      row1.send("guideline=", "global sample")
      row1.send("content=", "sample content")
      row2 = Row.new
      row2.send("guideline=", "global sample")
      row2.send("content=", "sample content")
      test4.send('rows=', [row2, row1])
      test4.remove_duplicate_rows_internal
      expect(test4.rows.length).to eq 1
      expect(test4.rows[0].instances).to eq 2
    end

    it 'can remove duplicates that occur within the same page 2 duplicates' do
      test5 = Page.new
      row1 = Row.new
      app_rows = []
      row1.send("guideline=", "global sample")
      row1.send("content=", "sample content")
      row2 = Row.new
      row2.send("guideline=", "global sample")
      row2.send("content=", "sample content")
      row3 = Row.new
      row3.send("guideline=", "global sample")
      row3.send("content=", "sample content")
      test5.send('rows=', [row2, row1, row3])
      test5.remove_duplicate_rows_internal
      expect(test5.rows.length).to eq 1
      expect(test5.rows[0].instances).to eq 3
    end


    it 'can combine both the internal and external together for one process' do
      app1 = Application.new
      page1 = Page.new
      page2 = Page.new
      app1.send("pages=", [page1, page2])
      test3 = Page.new
      app_row_1 = Row.new
      app_row_1.send("guideline=", "global sample")
      app_row_1.send("content=", "sample content")
      app_row_1.send("instances=", "2")
      app_row_2 = Row.new
      app_row_2.send("guideline=", "lobal sample")
      app_row_2.send("content=", "ample content")
      app_row_2.send("instances=", "2")
      row1 = Row.new
      row1.send("guideline=", "global sample")
      row1.send("content=", "sample content")
      row2 = Row.new
      row2.send("guideline=", "global ample")
      row2.send("content=", "sample ontent")
      row3 = Row.new
      row3.send("guideline=", "global ample")
      row3.send("content=", "sample ontent")

      page1.send("rows=", [app_row_1])
      page2.send("rows=", [app_row_2])
      test3.send("rows=", [row1, row2, row3])
      test3.remove_duplicates(app1)
      expect(test3.rows.length).to eq 1
      expect(app_row_1.instances.to_i).to eq 3
      expect(test3.rows[0].instances).to eq 2
      ;
    end
  end
  describe 'score calculation' do

    it 'can calculate and store the page score' do
      test6 = Page.new
      row1 = Row.new
      row1.send("guideline=", "aabbGuideline1_4.1_4_3.G145aabb")
      row1.send("content=", "sample content")
      row1.send("score=", 2)
      row2 = Row.new
      row2.send("guideline=", "aabbGuideline1_41_4_3.G145aabb")
      row2.send("content=", "sample content")
      row2.send("score=", 3)
      test6.send('rows=', [row2, row1])
      expect(test6.calc_page_score).to eq 5
    end

  end

end