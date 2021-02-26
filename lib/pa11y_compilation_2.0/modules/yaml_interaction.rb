module YAMLInteraction
  require 'yaml'

  def read_yaml(relative_location, data)
    return_yaml(relative_location)[data.upcase.tr(' ', '_')]
  end

  def key_value_add(file_location, key, value)
    hash = return_yaml(file_location)
    hash.store(key.upcase.tr(' ', '_'), value.to_s)
    yaml_dump(file_location, hash)
  end

  private

  def return_yaml(relative_location)
    YAML.load(File.read(relative_location))
  end

  def yaml_dump(file_location, hash)
    File.open(file_location, 'w+') {
        |file| YAML.dump(hash, file)}
  end


end