require 'sequel'
require 'dotenv'

Dotenv.load

database_url = if !ENV['HEROKU_POSTGRESQL_SILVER_URL'].nil?
                 ENV['HEROKU_POSTGRESQL_SILVER_URL']
               else
                 ENV['DATABASE_URL']
               end

DB = Sequel.connect(database_url)

require './app'

run App