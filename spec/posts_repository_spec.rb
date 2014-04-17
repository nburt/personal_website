require 'spec_helper'
require './lib/posts_repository'

describe PostsRepository do

  before do
    DB[:posts].delete
  end

  it 'should allow users to create a blog post with a title, body text, date, id, and an optional subtitle' do
    posts_repository = PostsRepository.new(DB)
    id1 = posts_repository.create({:title => 'Sinatra 101',
                                   :original_text => '#Header',
                                   :subtitle => 'An Intro',
                                   :slug => 'sinatra-101-an-intro',
                                   :rendered_text => %Q{<h1 id="header">Header</h1>\n},
                                   :date => Date.today,
                                   :original_post_format => 'markdown'})
    id2 =posts_repository.create({:title => 'Sinatra 102',
                                  :original_text => '#Header',
                                  :subtitle => '',
                                  :slug => 'sinatra-102',
                                  :rendered_text => %Q{<h1 id="header">Header</h1>\n},
                                  :date => Date.today,
                                  :original_post_format => 'markdown'})

    expect(posts_repository.display_all).to eq [
                                                 {:id => id1,
                                                  :title => 'Sinatra 101',
                                                  :subtitle => 'An Intro',
                                                  :original_text => '#Header',
                                                  :date => Date.today,
                                                  :slug => 'sinatra-101-an-intro',
                                                  :rendered_text => %Q{<h1 id="header">Header</h1>\n},
                                                  :original_post_format => 'markdown'},
                                                 {:id => id2,
                                                  :title => 'Sinatra 102',
                                                  :subtitle => '',
                                                  :original_text => '#Header',
                                                  :date => Date.today,
                                                  :slug => 'sinatra-102',
                                                  :rendered_text => %Q{<h1 id="header">Header</h1>\n},
                                                  :original_post_format => 'markdown'}
                                               ]
  end

  it 'should allow a user to grab the 10 most recent blog posts' do
    posts_repository = PostsRepository.new(DB)
    posts_repository.create({:title => 'Sinatra 101', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-101-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :date => Date.today})
    posts_repository.create({:title => 'Sinatra 102', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-102-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :date => Date.today})
    posts_repository.create({:title => 'Sinatra 103', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-103-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :date => Date.today})
    posts_repository.create({:title => 'Sinatra 104', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-104-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :date => Date.today})
    posts_repository.create({:title => 'Sinatra 105', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-105-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :date => Date.today})
    posts_repository.create({:title => 'Sinatra 106', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-106-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :date => Date.today})
    posts_repository.create({:title => 'Sinatra 107', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-107-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :date => Date.today})
    posts_repository.create({:title => 'Sinatra 108', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-108-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :date => Date.today})
    posts_repository.create({:title => 'Sinatra 109', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-109-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :date => Date.today})
    posts_repository.create({:title => 'Sinatra 110', :original_text => '#Header', :subtitle => '', :slug => 'sinatra-110', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :date => Date.today})

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
    posts_repository.create({:title => 'Sinatra 101', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-101-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :date => Date.today})
    expect(posts_repository.get_post_by_slug('sinatra-101-an-intro').attributes).to eq({:title => 'Sinatra 101',
                                                                                        :subtitle => 'An Intro',
                                                                                        :original_text => '#Header',
                                                                                        :rendered_text => %Q{<h1 id="header">Header</h1>\n},
                                                                                        :slug => 'sinatra-101-an-intro',
                                                                                        :date => Date.today.strftime('%-m/%-d/%Y')})
  end

  it 'should allow a user to update a blog post' do
    posts_repository = PostsRepository.new(DB)
    posts_repository.create({:title => 'Sinatra 101', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-101-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :date => Date.today})
    posts_repository.update('sinatra-101-an-intro', {:subtitle => 'A New Intro', :original_text => '#Header2', :slug => 'sinatra-101-a-new-intro', :rendered_text => %Q{<h1 id="header">Header2</h1>\n}})
    expect(posts_repository.get_post_by_slug('sinatra-101-a-new-intro').attributes).to eq({:title => 'Sinatra 101',
                                                                                :subtitle => 'A New Intro',
                                                                                :original_text => '#Header2',
                                                                                :rendered_text => %Q{<h1 id="header">Header2</h1>\n},
                                                                                :slug => 'sinatra-101-a-new-intro',
                                                                                :date => posts_repository.get_date_by_slug('sinatra-101-a-new-intro')})
  end
end
