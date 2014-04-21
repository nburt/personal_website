require 'spec_helper'
require './lib/blog_title_validator'
require './lib/posts_repository'

describe BlogTitleValidator do

  before do
    DB[:posts].delete
    DB[:comments].delete
  end

  it 'should display an error if the blog title has already been used' do
    posts_repository = PostsRepository.new(DB)
    posts_repository.create({:title => 'Sinatra 101', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-101-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :time => Time.now})
    blog_title_validator = BlogTitleValidator.new(DB)
    result = blog_title_validator.validate('Sinatra 101', 'An Intro')

    expect(result.success?).to eq false
    expect(result.error_message).to eq 'That blog title has already been chosen.'
  end

  it 'should not display an error if the blog title is the same but the subtitle is different' do
    posts_repository = PostsRepository.new(DB)
    posts_repository.create({:title => 'Sinatra 101', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-101-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :time => Time.now})
    blog_title_validator = BlogTitleValidator.new(DB)
    result = blog_title_validator.validate('Sinatra 101', 'An Ending')

    expect(result.success?).to eq true
    expect(result.error_message).to eq ''
  end
end