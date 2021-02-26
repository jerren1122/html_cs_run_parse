class RowHTML < HTML
  def build
    self.send("data_location=", File.expand_path("../../../data/html_data/row_data.yaml", __FILE__))
    row = read_yaml(data_location, "TR")
    data_cell = read_yaml(data_location, "TD")
    cells = object.values.map do |key|
      data_cell.gsub("sample", (htmlify(object.send(key)).to_s))
    end
    cells.push(data_cell.gsub("sample", htmlify(object.instances.to_i.to_s)))
    row.gsub("sample", cells.join.to_s)
  end

end