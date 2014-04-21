require 'sequel'
require 'capybara/rspec'
require 'dotenv'
require 'pry'

Dotenv.load

DB = Sequel.connect(ENV['TEST_DATABASE_URL'])

ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'
end

def the(message)
  yield
end

alias and_the the

module FeatureHelpers
  def i_create_a_blog_post(title, body='This is the new body')
    visit '/blog/new'
    fill_in 'title', :with => title
    fill_in 'subtitle', :with => 'A new subtitle'
    fill_in 'post_description', :with => 'This is a new description'
    fill_in 'original_text', :with => body
    click_button 'Create Post'
  end
end

RSpec.configure do |c|
  c.include FeatureHelpers
end