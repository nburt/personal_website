require 'spec_helper'
require './lib/posts_repository'

describe PostsRepository do

  before do
    DB[:posts].delete
    DB[:comments].delete
  end

  let(:posts_repository) { PostsRepository.new(DB) }

  it 'should allow users to create a blog post with a title, body text, date, id, and an optional subtitle' do
    time = Time.now
    id1 = posts_repository.create({:title => 'Sinatra 101',
                                   :original_text => '#Header',
                                   :subtitle => 'An Intro',
                                   :slug => 'sinatra-101-an-intro',
                                   :rendered_text => %Q{<h1 id="header">Header</h1>\n},
                                   :time => time,
                                   :original_post_format => 'markdown'})
    id2 =posts_repository.create({:title => 'Sinatra 102',
                                  :original_text => '#Header',
                                  :subtitle => '',
                                  :slug => 'sinatra-102',
                                  :rendered_text => %Q{<h1 id="header">Header</h1>\n},
                                  :time => time,
                                  :original_post_format => 'markdown'})

    expect(posts_repository.display_all).to eq [
                                                 {:id => id1,
                                                  :title => 'Sinatra 101',
                                                  :subtitle => 'An Intro',
                                                  :original_text => '#Header',
                                                  :time => time,
                                                  :slug => 'sinatra-101-an-intro',
                                                  :rendered_text => %Q{<h1 id="header">Header</h1>\n},
                                                  :original_post_format => 'markdown',
                                                  :post_description => nil},
                                                 {:id => id2,
                                                  :title => 'Sinatra 102',
                                                  :subtitle => '',
                                                  :original_text => '#Header',
                                                  :time => time,
                                                  :slug => 'sinatra-102',
                                                  :rendered_text => %Q{<h1 id="header">Header</h1>\n},
                                                  :original_post_format => 'markdown',
                                                  :post_description => nil}
                                               ]
  end

  it 'should allow a user to grab the 10 most recent blog posts and the next 10 most recent blog posts' do
    time = Time.now
    posts_repository.create({:title => 'Sinatra 101', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-101-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :time => time, :post_description => 'A Description'})
    posts_repository.create({:title => 'Sinatra 102', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-102-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :time => time, :post_description => 'A Description'})
    posts_repository.create({:title => 'Sinatra 103', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-103-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :time => time, :post_description => 'A Description'})
    posts_repository.create({:title => 'Sinatra 104', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-104-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :time => time, :post_description => 'A Description'})
    posts_repository.create({:title => 'Sinatra 105', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-105-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :time => time, :post_description => 'A Description'})
    posts_repository.create({:title => 'Sinatra 106', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-106-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :time => time, :post_description => 'A Description'})
    posts_repository.create({:title => 'Sinatra 107', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-107-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :time => time, :post_description => 'A Description'})
    posts_repository.create({:title => 'Sinatra 108', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-108-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :time => time, :post_description => 'A Description'})
    posts_repository.create({:title => 'Sinatra 109', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-109-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :time => time, :post_description => 'A Description'})
    posts_repository.create({:title => 'Sinatra 110', :original_text => '#Header', :subtitle => '', :slug => 'sinatra-110', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :time => time, :post_description => 'A Description'})
    posts_repository.create({:title => 'Sinatra 111', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-111-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :time => time, :post_description => 'A Description'})
    posts_repository.create({:title => 'Sinatra 112', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-112-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :time => time, :post_description => 'A Description'})
    posts_repository.create({:title => 'Sinatra 113', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-113-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :time => time, :post_description => 'A Description'})
    posts_repository.create({:title => 'Sinatra 114', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-114-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :time => time, :post_description => 'A Description'})
    posts_repository.create({:title => 'Sinatra 115', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-115-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :time => time, :post_description => 'A Description'})
    posts_repository.create({:title => 'Sinatra 116', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-116-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :time => time, :post_description => 'A Description'})
    posts_repository.create({:title => 'Sinatra 117', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-117-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :time => time, :post_description => 'A Description'})
    posts_repository.create({:title => 'Sinatra 118', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-118-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :time => time, :post_description => 'A Description'})
    posts_repository.create({:title => 'Sinatra 119', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-119-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :time => time, :post_description => 'A Description'})
    posts_repository.create({:title => 'Sinatra 120', :original_text => '#Header', :subtitle => '', :slug => 'sinatra-120', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :time => time, :post_description => 'A Description'})

    expect(posts_repository.get_recent_posts).to eq [
                                                      {:title => 'Sinatra 101', :subtitle => 'An Intro', :slug => 'sinatra-101-an-intro', :time => time, :full_title => 'Sinatra 101: An Intro', :post_description => 'A Description'},
                                                      {:title => 'Sinatra 102', :subtitle => 'An Intro', :slug => 'sinatra-102-an-intro', :time => time, :full_title => 'Sinatra 102: An Intro', :post_description => 'A Description'},
                                                      {:title => 'Sinatra 103', :subtitle => 'An Intro', :slug => 'sinatra-103-an-intro', :time => time, :full_title => 'Sinatra 103: An Intro', :post_description => 'A Description'},
                                                      {:title => 'Sinatra 104', :subtitle => 'An Intro', :slug => 'sinatra-104-an-intro', :time => time, :full_title => 'Sinatra 104: An Intro', :post_description => 'A Description'},
                                                      {:title => 'Sinatra 105', :subtitle => 'An Intro', :slug => 'sinatra-105-an-intro', :time => time, :full_title => 'Sinatra 105: An Intro', :post_description => 'A Description'},
                                                      {:title => 'Sinatra 106', :subtitle => 'An Intro', :slug => 'sinatra-106-an-intro', :time => time, :full_title => 'Sinatra 106: An Intro', :post_description => 'A Description'},
                                                      {:title => 'Sinatra 107', :subtitle => 'An Intro', :slug => 'sinatra-107-an-intro', :time => time, :full_title => 'Sinatra 107: An Intro', :post_description => 'A Description'},
                                                      {:title => 'Sinatra 108', :subtitle => 'An Intro', :slug => 'sinatra-108-an-intro', :time => time, :full_title => 'Sinatra 108: An Intro', :post_description => 'A Description'},
                                                      {:title => 'Sinatra 109', :subtitle => 'An Intro', :slug => 'sinatra-109-an-intro', :time => time, :full_title => 'Sinatra 109: An Intro', :post_description => 'A Description'},
                                                      {:title => 'Sinatra 110', :subtitle => '', :slug => 'sinatra-110', :time => time, :full_title => 'Sinatra 110', :post_description => 'A Description'},
                                                    ]

    expect(posts_repository.get_recent_posts(1, 10)).to eq [
                                                      {:title => 'Sinatra 111', :subtitle => 'An Intro', :slug => 'sinatra-111-an-intro', :time => time, :full_title => 'Sinatra 111: An Intro', :post_description => 'A Description'},
                                                      {:title => 'Sinatra 112', :subtitle => 'An Intro', :slug => 'sinatra-112-an-intro', :time => time, :full_title => 'Sinatra 112: An Intro', :post_description => 'A Description'},
                                                      {:title => 'Sinatra 113', :subtitle => 'An Intro', :slug => 'sinatra-113-an-intro', :time => time, :full_title => 'Sinatra 113: An Intro', :post_description => 'A Description'},
                                                      {:title => 'Sinatra 114', :subtitle => 'An Intro', :slug => 'sinatra-114-an-intro', :time => time, :full_title => 'Sinatra 114: An Intro', :post_description => 'A Description'},
                                                      {:title => 'Sinatra 115', :subtitle => 'An Intro', :slug => 'sinatra-115-an-intro', :time => time, :full_title => 'Sinatra 115: An Intro', :post_description => 'A Description'},
                                                      {:title => 'Sinatra 116', :subtitle => 'An Intro', :slug => 'sinatra-116-an-intro', :time => time, :full_title => 'Sinatra 116: An Intro', :post_description => 'A Description'},
                                                      {:title => 'Sinatra 117', :subtitle => 'An Intro', :slug => 'sinatra-117-an-intro', :time => time, :full_title => 'Sinatra 117: An Intro', :post_description => 'A Description'},
                                                      {:title => 'Sinatra 118', :subtitle => 'An Intro', :slug => 'sinatra-118-an-intro', :time => time, :full_title => 'Sinatra 118: An Intro', :post_description => 'A Description'},
                                                      {:title => 'Sinatra 119', :subtitle => 'An Intro', :slug => 'sinatra-119-an-intro', :time => time, :full_title => 'Sinatra 119: An Intro', :post_description => 'A Description'},
                                                      {:title => 'Sinatra 120', :subtitle => '', :slug => 'sinatra-120', :time => time, :full_title => 'Sinatra 120', :post_description => 'A Description'},
                                                    ]
  end

  it 'should allow a user to access a table row with a slug' do
    time = Time.now
    posts_repository.create({:title => 'Sinatra 101', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-101-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :time => time})
    expect(posts_repository.get_post_by_slug('sinatra-101-an-intro').attributes).to eq({:title => 'Sinatra 101',
                                                                                        :subtitle => 'An Intro',
                                                                                        :original_text => '#Header',
                                                                                        :rendered_text => %Q{<h1 id="header">Header</h1>\n},
                                                                                        :post_description => nil,
                                                                                        :slug => 'sinatra-101-an-intro',
                                                                                        :time => time.strftime('%-m/%-d/%Y')})
  end

  it 'should allow an admin to update a blog post' do
    time = Time.now
    posts_repository.create({:title => 'Sinatra 101', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-101-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :time => time})
    posts_repository.update_by_slug('sinatra-101-an-intro', {:subtitle => 'A New Intro', :original_text => '#Header2', :slug => 'sinatra-101-a-new-intro', :rendered_text => %Q{<h1 id="header">Header2</h1>\n}})
    expect(posts_repository.get_post_by_slug('sinatra-101-a-new-intro').attributes).to eq({:title => 'Sinatra 101',
                                                                                :subtitle => 'A New Intro',
                                                                                :original_text => '#Header2',
                                                                                :rendered_text => %Q{<h1 id="header">Header2</h1>\n},
                                                                                :post_description => nil,
                                                                                :slug => 'sinatra-101-a-new-intro',
                                                                                :time => posts_repository.get_time_by_slug('sinatra-101-a-new-intro')})
  end

  it 'should allow an admin to update a blog post' do
    time = Time.now
    posts_repository.create({:title => 'Sinatra 101', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-101-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :time => time})
    posts_repository.delete_by_slug('sinatra-101-an-intro')
    expect(posts_repository.get_post_by_slug('sinatra-101-an-intro')).to eq nil
  end

  it 'should allow you to get a post id by slug' do
    time = Time.now
    post_id = posts_repository.create({:title => 'Sinatra 101', :original_text => '#Header', :subtitle => 'An Intro', :slug => 'sinatra-101-an-intro', :rendered_text => %Q{<h1 id="header">Header</h1>\n}, :time => time})
    expect(posts_repository.get_id_by_slug('sinatra-101-an-intro')).to eq post_id
  end

end
