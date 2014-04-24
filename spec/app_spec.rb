require 'spec_helper'
require './app'
require 'capybara/rspec'

Capybara.app = App

feature 'Visitor can view and visit all the pages' do

  before do
    DB[:posts].delete
    DB[:comments].delete
    visit '/login'
    fill_in 'password', :with => ENV['PASSWORD']
    click_button 'Login'
  end

  scenario 'a user can create a new blog post' do
    visit '/blog'
    click_link 'Create a New Blog Post'
    within '#form_header' do
      expect(page).to have_content 'Create New Blog'
    end

    i_create_a_blog_post 'Sinatra 103'

    within '#blog_title' do
      expect(page).to have_content 'Sinatra 103'
    end
    within '#blog_subtitle' do
      expect(page).to have_content 'A new subtitle'
    end
    expect(page).to have_content 'This is the new body'
    expect(page).to have_content Time.now.strftime('%-m/%-d/%Y')

    and_the 'user will see the latest blog posts on the right hand side of individual blog pages' do
      within '#blog_list_container' do
        click_link 'Sinatra 103: A new subtitle'
      end
      within '#blog_title' do
        expect(page).to have_content 'Sinatra 103'
      end
    end

    and_the 'user can view recent blog posts on the main blog page' do
      visit '/blog'
      expect(page).to have_content 'Sinatra 103: A new subtitle'
      expect(page).to have_content 'This is a new description'
    end
  end

  scenario 'a user can create a new blog post without a subtitle' do
    visit '/blog/new'

    fill_in 'title', :with => 'Sinatra 103'
    fill_in 'subtitle', :with => ''
    fill_in 'post_description', :with => 'This is the description'
    fill_in 'original_text', :with => 'This is the body of my blog post'
    click_button 'Create Post'

    within '#blog_title' do
      expect(page).to have_content 'Sinatra 103'
    end

    expect(page).to have_content 'This is the body of my blog post'
    expect(page).to have_content Time.now.strftime('%-m/%-d/%Y')

    visit '/blog'
    expect(page).to have_content 'This is the description'
  end

  scenario 'an admin can edit a blog that has previously been created, the fields will be populated with the post\'s original information' do
    i_create_a_blog_post 'Sinatra 103', 'This is the body of my blog post'
    click_link 'Edit Blog Post'

    expect(page).to have_content 'This is the body of my blog post'
    expect(page).to have_content 'Meta Description'
    expect(page).to have_content 'This is a new description'
    fill_in 'title', :with => 'New Title'
    fill_in 'subtitle', :with => 'Now there is a subtitle'
    fill_in 'meta_description', :with => 'New meta description'
    fill_in 'post_description', :with => 'This is a newer description'
    fill_in 'original_text', :with => 'This is the new body'
    click_button 'Edit Blog Post'
    expect(page).to have_content 'Now there is a subtitle'
    expect(page).to have_content 'This is the new body'
  end

  scenario 'an admin can delete a previously created blog post' do
    i_create_a_blog_post 'Sinatra 103'

    click_button 'Delete Blog Post'
    expect(page).to_not have_content 'Sinatra 103'
    expect(page).to_not have_content 'Params'
  end

  scenario 'a user will be redirected to a 404 page if the page does not exist' do
    visit '/blog/blog'
    expect(page).to have_content 'Sorry, the page you were looking for cannot be found.'
    visit '/bloggy'
    expect(page).to have_content 'Sorry, the page you were looking for cannot be found.'
  end

  scenario 'if there are more then 10 blogs, the older ones will roll over onto the next page' do

    i_create_a_blog_post 'New Title 0'
    i_create_a_blog_post 'New Title 1'
    i_create_a_blog_post 'New Title 2'
    i_create_a_blog_post 'New Title 3'
    i_create_a_blog_post 'New Title 4'
    i_create_a_blog_post 'New Title 5'
    i_create_a_blog_post 'New Title 6'
    i_create_a_blog_post 'New Title 7'
    i_create_a_blog_post 'New Title 8'
    i_create_a_blog_post 'New Title 9'
    i_create_a_blog_post 'New Title 10'

    visit '/blog'
    expect(page).to_not have_content 'New Title 0'
    click_link 'Older Posts'
    expect(page).to have_content 'New Title 0'
  end

  scenario 'there is an ellipsis and a read more link at the end of blog preview text' do
    i_create_a_blog_post 'New Title', 'This is the new body'
    visit '/blog'
    expect(page).to have_content '...'
    click_link 'Read More'
    expect(page).to have_content 'New Title'
    expect(page).to have_content 'This is the new body'
  end

  scenario 'visitors can comment on posts' do
    i_create_a_blog_post 'New Title'
    fill_in 'name', :with => 'Nate'
    fill_in 'comment', :with => 'This is a comment'
    click_button 'Post Comment'
    expect(page).to have_content 'Nate'
    expect(page).to have_content 'This is a comment'
    within '#comment_container' do
      expect(page).to have_content "#{Time.now.strftime('%-m/%-d/%Y %l:%M %p')}"
    end
  end

  scenario 'admin can create meta description with post' do
    i_create_a_blog_post 'New Title'
    page.should have_css "meta[name='description'][content='Meta Description']", :visible => false
  end

  scenario 'admin can add tags to a post' do
    i_create_a_blog_post 'New Title'
    click_link 'Sinatra'
    expect(page).to have_content 'New Title'
    expect(page).to have_content 'A new subtitle'
    visit '/blog/new-title-a-new-subtitle'
    click_link 'Ruby'
    expect(page).to have_content 'New Title'
    expect(page).to have_content 'A new subtitle'
  end

  scenario 'if there are exactly 10 posts on a page, there will not be an older posts link' do

    i_create_a_blog_post 'New Title 1'
    i_create_a_blog_post 'New Title 2'
    i_create_a_blog_post 'New Title 3'
    i_create_a_blog_post 'New Title 4'
    i_create_a_blog_post 'New Title 5'
    i_create_a_blog_post 'New Title 6'
    i_create_a_blog_post 'New Title 7'
    i_create_a_blog_post 'New Title 8'
    i_create_a_blog_post 'New Title 9'
    i_create_a_blog_post 'New Title 10'

    visit '/blog'
    expect(page).to_not have_link 'Older Posts'
  end

  scenario 'if there are exactly 10 posts on a page after the first page, there will not be an older posts link' do

    i_create_a_blog_post 'New Title 1'
    i_create_a_blog_post 'New Title 2'
    i_create_a_blog_post 'New Title 3'
    i_create_a_blog_post 'New Title 4'
    i_create_a_blog_post 'New Title 5'
    i_create_a_blog_post 'New Title 6'
    i_create_a_blog_post 'New Title 7'
    i_create_a_blog_post 'New Title 8'
    i_create_a_blog_post 'New Title 9'
    i_create_a_blog_post 'New Title 10'
    i_create_a_blog_post 'New Title 11'
    i_create_a_blog_post 'New Title 12'
    i_create_a_blog_post 'New Title 13'
    i_create_a_blog_post 'New Title 14'
    i_create_a_blog_post 'New Title 15'
    i_create_a_blog_post 'New Title 16'
    i_create_a_blog_post 'New Title 17'
    i_create_a_blog_post 'New Title 18'
    i_create_a_blog_post 'New Title 19'
    i_create_a_blog_post 'New Title 20'

    visit '/blog/page/2'
    expect(page).to_not have_link 'Older Posts'
  end

  scenario 'an admin can edit comments' do
    i_create_a_blog_post 'New Title 1'
    fill_in 'name', :with => 'Nate'
    fill_in 'comment', :with => 'A comment'
    click_button 'Post Comment'
    click_link 'View Comment'
    expect(page).to have_content 'Nate'
    expect(page).to have_content 'A comment'
    click_link 'Edit Comment'
    fill_in 'name', :with => 'Nathanael'
    click_button 'Edit Comment'
    expect(page).to have_content 'Nathanael'
    expect(page).to have_content 'A comment'
  end

  scenario 'an admin can delete comments' do
    i_create_a_blog_post 'New Title 1'
    fill_in 'name', :with => 'Nate'
    fill_in 'comment', :with => 'A comment'
    click_button 'Post Comment'
    click_link 'View Comment'
    expect(page).to have_content 'Nate'
    expect(page).to have_content 'A comment'
    click_button 'Delete Comment'
    expect(page).to_not have_content 'Nate'
    expect(page).to_not have_content 'A comment'
  end

end
