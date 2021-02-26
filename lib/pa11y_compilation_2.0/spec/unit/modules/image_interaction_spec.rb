require './modules/image_interaction'
include ImageInteraction

describe 'image retention' do
  it 'can move an image from a saved file to a variable back to a file' do
    file_content = retrieve_image_content("./spec/unit/data/expected/crayons.png")
    place_image_content("./spec/unit/data/expected/crayons", file_content)
    mtime = File.open("./spec/unit/data/expected/crayons.png", 'r'){|file|@output = file.mtime }
    expect(mtime).to be > Time.now - 20
  end

  it 'can locate files' do
    expect(return_all_files("./spec/unit/data/expected", "png").length).to eq 1
  end
end