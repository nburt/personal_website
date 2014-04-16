require 'spec_helper'
require './lib/post'

describe Post do

  it 'can take a slug hash and access all the attributes of a post' do
    post = Post.new({:slug => 'title2-subtitle'})
    expect(post.attributes).to eq({:slug => 'title2-subtitle'})
  end

  it 'should allow a user to create a slug with the title and subtitle' do
    post = Post.new({:title => 'Sinatra 101', :subtitle => 'An Intro'})
    expect(post.create_slug).to eq('sinatra-101-an-intro')
  end

  it 'should allow a user to create a slug with the title and an empty subtitle' do
    post = Post.new({:title => 'Sinatra 101', :subtitle => ''})
    expect(post.create_slug).to eq('sinatra-101')
  end
end