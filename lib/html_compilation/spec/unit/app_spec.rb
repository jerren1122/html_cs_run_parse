require './classes/objects/app'
require './classes/objects/page'
require './classes/objects/row'
describe "Application functionality" do
  describe "storage and access" do

    it 'can set and retrieve the application name' do
      test1 = Application.new
      test1.send("application_name=", "Sample app")
      expect(test1.application_name).to eq "Sample app"
    end

    it 'stores the guidelines and scores for the app' do
      test2 = Application.new
      test2.send("application_name=", "sample score and guideline")
      expect(test2.application_name).to eq "sample score and guideline"
    end

    it 'can access all individual pages' do
      test3 = Application.new
      test3.send("pages=", "sample page")
      expect(test3.pages).to eq "sample page"
    end

  end

  describe 'calculation' do

    it 'can calculate app score given all the individual page scores' do
      test4 = Application.new
      sample_1 = Page.new
      sample_1.send("score=", 2)
      sample_2 = Page.new
      sample_2.send("score=", 3)
      test4.send("pages=", [sample_1, sample_2])
      expect(test4.calculate_app_score).to eq 5
    end

    it 'can calculate total errors' do
      test5 = Application.new
      rows = [1,2]
      sample_1 = Page.new
      sample_1.send("score=", 2)
      sample_1.send("rows=", rows)
      sample_2 = Page.new
      sample_2.send("rows=", rows)
      test5.send("pages=", [sample_1, sample_2])
      expect(test5.calculate_total_errors).to eq 4

    end

  end

  describe 'duplication' do

    it 'can update this running lists instance element for any object' do
      app = Application.new
      page1 = Page.new
      page2 = Page.new
      page3 = Page.new
      app.send("pages=", [page1, page2, page3])
      arow_1 = Row.new
      arow_1.send("guideline=", "global sample")
      arow_1.send("content=", "sample content")
      arow_2 = Row.new
      arow_2.send("guideline=", "lobal sample")
      arow_2.send("content=", "ample content")
      row1 = Row.new
      row1.send("guideline=", "global sample")
      row1.send("content=", "sample content")
      row2 = Row.new
      row2.send("guideline=", "global ample")
      row2.send("content=", "sample ontent")
      row3 = Row.new
      row3.send("guideline=", "global ample")
      row3.send("content=", "sample ontent")
      page1.send("rows=", [arow_1])
      page2.send("rows=", [arow_2])
      page3.send("rows=", [row1, row2, row3])
      app.remove_duplicates
      expect(app.pages[0].rows.length).to eq 1
      expect(app.pages[0].rows[0].instances).to eq 2
      expect(app.pages[1].rows.length).to eq 1
      expect(app.pages[1].rows[0].instances).to eq 1
      expect(app.pages[2].rows.length).to eq 1
      expect(app.pages[2].rows[0].instances).to eq 2
    end
  end
end