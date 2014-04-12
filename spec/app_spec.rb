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
    fill_in 'post_body', :with => 'This is the body of my blog post'
    click_button 'Create Post'

    within 'h1' do
      expect(page).to have_content 'Sinatra 103'
    end
    within 'h4' do
      expect(page).to have_content 'A Brief Intro'
    end
    expect(page).to have_content 'This is the body of my blog post'
    expect(page).to have_content Date.today.strftime('%-m/%-d/%Y')
  end

end
