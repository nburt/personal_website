class Post
  attr_reader :attributes
  def initialize(attributes)
    @attributes = attributes
  end

  def create_slug
    if @attributes[:subtitle].empty?
      "#{@attributes[:title].gsub(' ', '-').downcase}"
    else
      title = @attributes[:title].gsub(' ', '-').downcase
      subtitle = @attributes[:subtitle].gsub(' ', '-').downcase
      "#{title}-#{subtitle}"
    end
  end
end