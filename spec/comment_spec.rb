require 'spec_helper'
require './lib/comment'

describe Comment do

  it 'initializes with a hash of attributes and can access them through an attr_reader' do
    comment = Comment.new({:name => 'Nate', :comment => 'A comment', :post_id => 1})
    expect(comment.attributes).to eq({:name => 'Nate', :comment => 'A comment', :post_id => 1})
  end
end
