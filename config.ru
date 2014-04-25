require 'sequel'
require 'dotenv'

Dotenv.load

DB = Sequel.connect(ENV['DATABASE_URL'])

require './app'

if ENV['RACK_ENV'] != 'test'
  Mail.defaults do
    delivery_method :smtp, {:address => "smtp.sendgrid.net",
                            :port => 587,
                            :domain => "nathanael-burt-blog-staging.herokuapp.com",
                            :user_name => ENV['SENDGRID_USERNAME'],
                            :password => ENV['SENDGRID_PASSWORD'],
                            :authentication => 'plain',
                            :enable_starttls_auto => true}
  end
end


run App