require 'spec_helper'
require './lib/posts_repository'

describe PostsRepository do

  before do
    DB[:posts].delete
  end

  it 'should allow users to create a blog post with a title, body text, date, id, and an optional subtitle' do
    posts_repository = PostsRepository.new(DB)
    id1 = posts_repository.create('Sinatra 101', 'This is the body text', 'An Intro', 'sinatra-101-an-intro', %Q{<h1 id="header">Header</h1>\n})
    id2 =posts_repository.create('Sinatra 102', 'This is new body text', '', 'sinatra-102', %Q{<h1 id="header">Header</h1>\n})

    expect(posts_repository.display_all).to eq [
                                                 {:id => id1,
                                                  :title => 'Sinatra 101',
                                                  :original_text => 'This is the body text',
                                                  :subtitle => 'An Intro',
                                                  :date => Date.today,
                                                  :slug => 'sinatra-101-an-intro',
                                                  :rendered_text => %Q{<h1 id="header">Header</h1>\n}},
                                                 {:id => id2,
                                                  :title => 'Sinatra 102',
                                                  :original_text => 'This is new body text',
                                                  :subtitle => nil,
                                                  :date => Date.today,
                                                  :slug => 'sinatra-102',
                                                  :rendered_text => %Q{<h1 id="header">Header</h1>\n}}
                                               ]
  end

  it 'should allow a user to grab the 10 most recent blog posts' do
    posts_repository = PostsRepository.new(DB)
    posts_repository.create('Sinatra 101', 'This is the body text', 'An Intro', 'sinatra-101-an-intro', %Q{<h1 id="header">Header1</h1>\n})
    posts_repository.create('Sinatra 102', 'This is the body text', 'An Intro', 'sinatra-102-an-intro', %Q{<h1 id="header">Header2</h1>\n})
    posts_repository.create('Sinatra 103', 'This is the body text', 'An Intro', 'sinatra-103-an-intro', %Q{<h1 id="header">Header3</h1>\n})
    posts_repository.create('Sinatra 104', 'This is the body text', 'An Intro', 'sinatra-104-an-intro', %Q{<h1 id="header">Header4</h1>\n})
    posts_repository.create('Sinatra 105', 'This is the body text', 'An Intro', 'sinatra-105-an-intro', %Q{<h1 id="header">Header5</h1>\n})
    posts_repository.create('Sinatra 106', 'This is the body text', 'An Intro', 'sinatra-106-an-intro', %Q{<h1 id="header">Header6</h1>\n})
    posts_repository.create('Sinatra 107', 'This is the body text', 'An Intro', 'sinatra-107-an-intro', %Q{<h1 id="header">Header7</h1>\n})
    posts_repository.create('Sinatra 108', 'This is the body text', 'An Intro', 'sinatra-108-an-intro', %Q{<h1 id="header">Header8</h1>\n})
    posts_repository.create('Sinatra 109', 'This is the body text', 'An Intro', 'sinatra-109-an-intro', %Q{<h1 id="header">Header9</h1>\n})
    posts_repository.create('Sinatra 110', 'This is the body text', '', 'sinatra-110', %Q{<h1 id="header">Header10</h1>\n})

    expect(posts_repository.get_recent_posts).to eq [
                                                      {:recent_titles => 'Sinatra 101: An Intro', :recent_urls => 'sinatra-101-an-intro', :date => Date.today},
                                                      {:recent_titles => 'Sinatra 102: An Intro', :recent_urls => 'sinatra-102-an-intro', :date => Date.today},
                                                      {:recent_titles => 'Sinatra 103: An Intro', :recent_urls => 'sinatra-103-an-intro', :date => Date.today},
                                                      {:recent_titles => 'Sinatra 104: An Intro', :recent_urls => 'sinatra-104-an-intro', :date => Date.today},
                                                      {:recent_titles => 'Sinatra 105: An Intro', :recent_urls => 'sinatra-105-an-intro', :date => Date.today},
                                                      {:recent_titles => 'Sinatra 106: An Intro', :recent_urls => 'sinatra-106-an-intro', :date => Date.today},
                                                      {:recent_titles => 'Sinatra 107: An Intro', :recent_urls => 'sinatra-107-an-intro', :date => Date.today},
                                                      {:recent_titles => 'Sinatra 108: An Intro', :recent_urls => 'sinatra-108-an-intro', :date => Date.today},
                                                      {:recent_titles => 'Sinatra 109: An Intro', :recent_urls => 'sinatra-109-an-intro', :date => Date.today},
                                                      {:recent_titles => 'Sinatra 110', :recent_urls => 'sinatra-110', :date => Date.today}

                                                    ]
  end

  it 'should allow a user to access a table row with a slug' do
    posts_repository = PostsRepository.new(DB)
    id = posts_repository.create('Sinatra 101', '#Header', 'An Intro', 'sinatra-101-an-intro', %Q{<h1 id="header">Header</h1>\n})
    expect(posts_repository.get_post_by_slug('sinatra-101-an-intro').attributes).to eq ({:title => 'Sinatra 101',
                                                                              :subtitle => 'An Intro',
                                                                              :date => Date.today.strftime('%-m/%-d/%Y'),
                                                                              :rendered_text => %Q{<h1 id="header">Header</h1>\n}})
  end

end
