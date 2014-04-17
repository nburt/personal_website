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
    within '#form_header' do
      expect(page).to have_content 'Create New Blog'
    end

    fill_in 'title', :with => 'Sinatra 103'
    fill_in 'subtitle', :with => 'A Brief Intro'
    fill_in 'original_text', :with => 'This is the body of my blog post'
    click_button 'Create Post'

    within '#blog_title' do
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
      within '#blog_title' do
        expect(page).to have_content 'Sinatra 103'
      end
    end

    and_the 'user can view recent blog posts on the main blog page' do
      visit '/blog'
      expect(page).to have_content 'Sinatra 103: A Brief Intro'
    end
  end

  scenario 'a user can create a new blog post without a subtitle' do
    visit '/blog'
    click_link 'Create a New Blog Post'
    within '#form_header' do
      expect(page).to have_content 'Create New Blog'
    end

    fill_in 'title', :with => 'Sinatra 103'
    fill_in 'subtitle', :with => ''
    fill_in 'original_text', :with => 'This is the body of my blog post'
    click_button 'Create Post'

    within '#blog_title' do
      expect(page).to have_content 'Sinatra 103'
    end

    expect(page).to have_content 'This is the body of my blog post'
    expect(page).to have_content Date.today.strftime('%-m/%-d/%Y')
  end

  scenario 'an admin can edit a blog that has previously been created, the fields will be populated with the post\'s original information' do
    visit '/blog'
    click_link 'Create a New Blog Post'
    within '#form_header' do
      expect(page).to have_content 'Create New Blog'
    end

    fill_in 'title', :with => 'Sinatra 103'
    fill_in 'subtitle', :with => ''
    fill_in 'original_text', :with => 'This is the body of my blog post'
    click_button 'Create Post'
    click_link 'Edit Blog Post'

    within 'textarea' do
      expect(page).to have_content 'This is the body of my blog post'
    end
    fill_in 'subtitle', :with => 'Now there is a subtitle'
    fill_in 'original_text', :with => 'This is the new body'
    click_button 'Edit Blog Post'
    expect(page).to have_content 'Now there is a subtitle'
    expect(page).to have_content 'This is the new body'
  end

  scenario 'an admin can delete a previously created blog post' do
    visit '/blog'
    click_link 'Create a New Blog Post'
    within '#form_header' do
      expect(page).to have_content 'Create New Blog'
    end

    fill_in 'title', :with => 'Sinatra 103'
    fill_in 'subtitle', :with => 'Params'
    fill_in 'original_text', :with => 'This is the body of my blog post'
    click_button 'Create Post'
    click_link 'Delete Blog Post'
    expect(page).to_not have_content 'Sinatra 103'
    expect(page).to_not have_content 'Params'
  end
end
