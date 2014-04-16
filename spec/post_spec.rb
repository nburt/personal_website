require 'spec_helper'
require './lib/post'
require './lib/posts_repository'

describe Post do

  it 'can take a slug hash and access all the attributes of a post' do
    post = Post.new({:slug => 'title2-subtitle'})
    expect(post.attributes).to eq({:slug => 'title2-subtitle'})
  end
end