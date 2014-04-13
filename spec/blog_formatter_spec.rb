require 'spec_helper'
require 'blog_formatter'

describe BlogFormatter do
  it 'will convert a blog from markdown to html' do
    formatter = BlogFormatter.new("#Header")
    expect(formatter.format).to eq %Q{<h1 id="header">Header</h1>\n}
  end
end