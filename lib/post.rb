require './lib/post_formatter'

class Post
  attr_reader :attributes
  def initialize(attributes)
    @attributes = attributes
    @attributes[:date] ||= Date.today
  end

  def create_slug
    if @attributes[:subtitle].empty?
      @attributes[:slug] = "#{@attributes[:title].gsub(' ', '-').downcase}"
    else
      title = @attributes[:title].gsub(' ', '-').downcase
      subtitle = @attributes[:subtitle].gsub(' ', '-').downcase
      @attributes[:slug] = "#{title}-#{subtitle}"
    end
  end

  def render_text
    if @attributes[:original_post_format] == 'markdown'
      @attributes[:rendered_text] = PostFormatter.new(@attributes[:original_text]).format
    else
      @attributes[:rendered_text] = @attributes[:original_text]
    end
  end
end