class BaseObject
  def initialize
    @values = []
  end

  def set_value(variable, content)
    self.send("#{variable}=", content)
    unless @values.include?(variable)
      @values.push(variable)
    end
  end
end