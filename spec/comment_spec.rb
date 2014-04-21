require 'spec_helper'
require './lib/comment'

describe Comment do

  it 'initializes with a hash of attributes including a time and can access them through an attr_reader' do
    comment = Comment.new({:name => 'Nate', :comment => 'A comment', :post_id => 1})
    expect(comment.attributes).to include({:name => 'Nate', :comment => 'A comment', :post_id => 1})
    expect(comment.attributes[:time]).to be_within(1).of(Time.now)
  end
end
