require 'spec_helper'
require './app'
require 'capybara/rspec'

Capybara.app = App

feature 'Visitor can view and visit all the pages' do

  scenario 'visitor can visit the homepage and follow links to the other pages' do
    visit '/'
    within 'nav' do
      click_link 'Home'
    end
    within 'h1' do
      expect(page).to have_content 'Nathanael Burt'
    end

    visit '/'
    within 'nav' do
      click_link 'Resume'
    end
    within 'h1' do
      expect(page).to have_content 'Nathanael Burt\'s Resume'
    end

    visit '/'
    within 'nav' do
      click_link 'Blog'
    end
    within 'h1' do
      expect(page).to have_content 'Nathanael Burt\'s Blog'
    end

    visit '/'
    within 'nav' do
      click_link 'Portfolio'
    end
    within 'h1' do
      expect(page).to have_content 'Nathanael Burt\'s Portfolio'
    end
  end

end
