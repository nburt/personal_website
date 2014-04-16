require 'spec_helper'
require './lib/post'

describe Post do

  it 'can take a slug hash and access all the attributes of a post and should initialize with the date' do
    post = Post.new({:slug => 'title2-subtitle'})
    expect(post.attributes).to eq({:slug => 'title2-subtitle', :date => Date.today})
  end

  it 'should allow a user to create a slug with the title and subtitle' do
    post = Post.new({:title => 'Sinatra 101', :subtitle => 'An Intro'})
    expect(post.create_slug).to eq('sinatra-101-an-intro')
  end

  it 'should allow a user to create a slug with the title and an empty subtitle' do
    post = Post.new({:title => 'Sinatra 101', :subtitle => ''})
    expect(post.create_slug).to eq('sinatra-101')
  end

  it 'should allow a user to create the rendered_text from the original text' do
    post = Post.new({:original_text => '#Header', :original_post_format => 'markdown'})
    expect(post.render_text).to eq(%Q{<h1 id="header">Header</h1>\n})
  end

  it 'should allow a user to leave the original text as is if it is already in html' do
    post = Post.new({:original_text => '<h1>Header</h1>'})
    expect(post.render_text).to eq('<h1>Header</h1>')
  end
end