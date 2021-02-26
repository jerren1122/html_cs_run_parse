module ImageInteraction
  #wonkavision
  def retrieve_image_content(file_location)
    File.read(file_location, mode: "rb")
  end

  def place_image_content(file_name, content, extension =".png")
    File.write(file_name + extension, content, mode: "wb:ASCII-8BIT")
  end

  def return_all_files(current_location, file_type = '*', filter = '*')
    Dir.glob("#{current_location}/#{filter}.#{file_type}")
  end
end