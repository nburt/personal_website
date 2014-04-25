###Initial setup
1. Change `scripts/create_databases.sql` to create both your development and test databases.
1. The app uses postgreSQL so make sure you have it installed
1. Create a `.env` file. Add the following text:

```
DATABASE_URL_DEVELOPMENT='postgres://<your local db user>:<your local db password>@localhost/<your development database name>'
DATABASE_URL_TEST='postgres://<your local db user>:<your local db password>@localhost/<your test database name>'
PASSWORD=password
```

Set PASSWORD to whatever you would like your password to be for the admin panel within your local development environment.

The .env file will be ignored by git, see `.gitignore`

###Development
1. `bundle install`
1. Create a database by running `psql -d postgres -f scripts/create_databases.sql`
1. Run the migrations in the development database using `rake db:migrate`.
1. `rerun rackup`
    * running rerun will reload app when file changes are detected
1. Run tests using `rspec`.
1. To access the admin section of the website, visit '/login' and enter your password
1. Use <a href="https://github.com/sj26/mailcatcher">mailcatcher</a> to send emails locally

###Heroku Staging
http://nathanael-burt-blog-staging.herokuapp.com/
