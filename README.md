# README

## Development setup

- Install ruby-2.7.2 - use whatever ruby manager you want (both rvm and rbenv will work). If you run into any issues finding this version, make sure `ruby-builder` is up to date.

### Dependencies

- Install the dependencies. Installation is OS dependent. You can use `brew` if using a MacOS. On Ubuntu you can use `sudo apt-get install.`
  * Node
  * Yarn
  * Postgres
  * Redis

> ### :exclamation: On Ubuntu and probably other linux distributions
> Yarn: `curl --compressed -o- -L https://yarnpkg.com/install.sh | bash`
>
> Postgres:
>  * Install `postgresql-contrib` and `libpq-dev` along with `postgresql`, see [tutorial][postgres-ubuntu-tutorial].
>
> Redis:
>  * Install `redis-server`
>  * Edit the `supervised` directive to `systemd`, see [tutorial][redis-ubuntu-tutorial].

- Create a new user with the password as specified in `database.yml` by using the postgres command `CREATE USER new_user with PASSWORD 'your_super_secret_password';`

- Start the services.
	> If you installed these with `brew`, you can start them with `brew services start <SERVICE>`. 
	> If you're using Ubuntu, you can check the status of these services with the `sudo systemctl status <SERVICE_NAME>` bash command.
  * Postgres
  * Redis

- Install gems with `bundle install`

### Adding and removing a new model

- If you need to remove a model, first migrate down the relevant version
```sh
rails db:migrate:down VERSION=<NUMBER>
```

- Then destroy the model
```sh
rails destroy model <MODEL_NAME>
```

#### Seeding the database

- All CSV files under `db/seed_data/` will automatically be used to seed the DB
- To add seeding data for a new table, create a new file under the mentioned directory that matches the table name
- All CSV files in the directory must contain a header row and columns matching (at least) all required fields
- See `db/seed_data/languages.csv` (which will seed the `languages` table) for an example

### Start up the app

- Get the database up and running: `rake db:create`

- Get the schema setup: `rake db:migrate`
> Note: if you make a change in a migration file that has not been committed and do not see the change reflected in the schema run `rake db:rollback` and rerun the migration.

- Start the app: `rails s`

[redis-ubuntu-tutorial]: https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-redis-on-ubuntu-20-04
	[postgres-ubuntu-tutorial]: https://www.digitalocean.com/community/tutorials/how-to-install-postgresql-on-ubuntu-20-04-quickstart
