require 'kramdown'

class BlogFormatter
  attr_reader :formatted_post

  def initialize(text)
    @text = text
    @formatted_post = ''
  end

  def format
    @formatted_post = Kramdown::Document.new(@text).to_html
  end

end