class SuppressedPageRules
  attr_accessor(:guideline, :content)

  def initialize(guideline, content)
    send("guideline=", guideline)
    send("content=", content)
  end
end