class Comment

  attr_reader :attributes

  def initialize(attributes)
    @attributes = attributes
    @attributes[:time] ||= Time.now
  end

end