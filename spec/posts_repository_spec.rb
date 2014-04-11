require 'spec_helper'
require './lib/posts_repository'

describe PostsRepository do

  before do
    DB[:posts].delete
  end

  it 'should allow users to create a blog post with a title, body text, date, id, and an optional subtitle' do
    posts_repository = PostsRepository.new(DB)
    id1 = posts_repository.create('Sinatra 101', 'This is the body text', 'An Intro')
    id2 =posts_repository.create('Sinatra 102', 'This is new body text', '')

    expect(posts_repository.display_all).to eq [
                                                {:id => id1,
                                                  :title => 'Sinatra 101',
                                                  :post_body => 'This is the body text',
                                                  :subtitle => 'An Intro',
                                                  :date => Date.today},
                                                {:id => id2,
                                                  :title => 'Sinatra 102',
                                                  :post_body => 'This is new body text',
                                                  :subtitle => nil,
                                                  :date => Date.today}
                                               ]
  end

  it 'should allow users to grab individual columns from the table by title' do
    posts_repository = PostsRepository.new(DB)
    posts_repository.create('Sinatra 101', 'This is the body text', 'An Intro')

    expect(posts_repository.get_post_body('Sinatra 101')).to eq 'This is the body text'
    expect(posts_repository.get_subtitle('Sinatra 101')).to eq 'An Intro'
    expect(posts_repository.get_date('Sinatra 101')).to eq Date.today
  end

end
