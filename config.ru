require 'sequel'
require 'dotenv'

Dotenv.load

DB = Sequel.connect(ENV['DATABASE_URL'])

require './app'

run App