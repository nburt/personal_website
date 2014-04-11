require 'sequel'
require 'capybara/rspec'
require 'dotenv'

Dotenv.load

DB = Sequel.connect(ENV['TEST_DATABASE_URL'])

ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'
end

