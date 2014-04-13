require 'spec_helper'
require './lib/posts_repository'

describe PostsRepository do

  before do
    DB[:posts].delete
  end

  it 'should allow users to create a blog post with a title, body text, date, id, and an optional subtitle' do
    posts_repository = PostsRepository.new(DB)
    id1 = posts_repository.create('Sinatra 101', 'This is the body text', 'An Intro', 'sinatra-101-an-intro')
    id2 =posts_repository.create('Sinatra 102', 'This is new body text', '', 'sinatra-102')

    expect(posts_repository.display_all).to eq [
                                                {:id => id1,
                                                  :title => 'Sinatra 101',
                                                  :original_text => 'This is the body text',
                                                  :subtitle => 'An Intro',
                                                  :date => Date.today,
                                                  :slug => 'sinatra-101-an-intro',
                                                  :rendered_text => nil},
                                                {:id => id2,
                                                  :title => 'Sinatra 102',
                                                  :original_text => 'This is new body text',
                                                  :subtitle => nil,
                                                  :date => Date.today,
                                                  :slug => 'sinatra-102',
                                                  :rendered_text => nil}
                                               ]
  end

  it 'should allow users to grab individual columns from the table by title' do
    posts_repository = PostsRepository.new(DB)
    posts_repository.create('Sinatra 101', 'This is the body text', 'An Intro', 'sinatra-101-an-intro')

    expect(posts_repository.get_title('sinatra-101-an-intro')).to eq 'Sinatra 101'
    expect(posts_repository.get_original_text('sinatra-101-an-intro')).to eq 'This is the body text'
    expect(posts_repository.get_subtitle('sinatra-101-an-intro')).to eq 'An Intro'
    expect(posts_repository.get_date('sinatra-101-an-intro')).to eq Date.today
  end

end
