require 'spec_helper'
require './app'
require 'capybara/rspec'

Capybara.app = App

feature 'Visitor can view and visit all the pages' do

  before do
    visit '/login'
    fill_in 'password', :with => ENV['PASSWORD']
    click_button 'Login'
    expect(page).to have_content 'Welcome, admin!'
    DB[:posts].delete
  end

  scenario 'a user can create a new blog post' do
    visit '/blog'
    click_link 'Create a New Blog Post'
    within 'h1' do
      expect(page).to have_content 'Create New Blog'
    end
    fill_in 'title', :with => 'Sinatra 103'
    fill_in 'subtitle', :with => 'A Brief Intro'
    fill_in 'original_text', :with => 'This is the body of my blog post'
    click_button 'Create Post'

    within 'h1' do
      expect(page).to have_content 'Sinatra 103'
    end
    within 'h4' do
      expect(page).to have_content 'A Brief Intro'
    end
    expect(page).to have_content 'This is the body of my blog post'
    expect(page).to have_content Date.today.strftime('%-m/%-d/%Y')

    and_the 'user will see the latest blog posts on the right hand side of individual blog pages' do
      within '#blog_list_container' do
        click_link 'Sinatra 103: A Brief Intro'
      end
      within 'h1' do
        expect(page).to have_content 'Sinatra 103'
      end
    end

    and_the 'user can view recent blog posts on the main blog page' do
      visit '/blog'
      expect(page).to have_content 'Sinatra 103: A Brief Intro'
    end
  end
end
