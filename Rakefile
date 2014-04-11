namespace :db do
  task :sequel do
    begin
      require 'dotenv'
      Dotenv.load
    rescue LoadError
    end
    require "sequel"
    Sequel.extension :migration
    DB = Sequel.connect(ENV['DATABASE_URL'])
    DB_TEST = Sequel.connect(ENV['TEST_DATABASE_URL'])
  end

  desc "Prints current schema version"
  task :version => :sequel do
    version = if DB.tables.include?(:schema_info)
                DB[:schema_info].first[:version]
              end || 0

    puts "Schema Version: #{version}"

    version_test = if DB_TEST.tables.include?(:schema_info)
                     DB_TEST[:schema_info].first[:version]
                   end || 0

    puts "Test Schema Version: #{version_test}"
  end

  desc "Perform migration up to latest migration available"
  task :migrate => :sequel do
    Sequel::Migrator.run(DB, "migrations")
    Sequel::Migrator.run(DB_TEST, "migrations")
    Rake::Task['db:version'].execute
  end
end