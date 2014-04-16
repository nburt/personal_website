require 'spec_helper'
require 'post_formatter'

describe PostFormatter do
  it 'will convert a blog from markdown to html' do
    formatter = PostFormatter.new("#Header")
    expect(formatter.format).to eq %Q{<h1 id="header">Header</h1>\n}
  end
end