# BenarID

[![Build Status](https://travis-ci.org/BenarID/benarid-server.svg?branch=master)](https://travis-ci.org/BenarID/benarid-server)

BenarID is a crowdsourced, collaborative Indonesian news rating app.

This is the repo for the server component for the API and website.

This is still a work in progress!

## Whitelisted news portals

We whitelist news portals to make sure that BenarID only works on valid articles. We don't want it to work on every page you visit (and our DB would explode :smile:).

See [this directory](./priv/portals) for a list of currently whitelisted portals.

## Contributing

Thanks for wanting to contribute! This section will explain how to get up and running on developing this project. There are several ways you can contribute.

### Reporting Bugs and Feature Requests

Found a bug? Requesting a feature? Want to add a news portal to BenarID whitelist? [Fire up an issue](https://github.com/BenarID/benarid-server/issues/new)!

If it's a bug, please provide the steps required to reproduce it as detailed as you can. Help us to help you.

### Developing

We need all the help we can get, so if you're a fellow developer, this section is for you.

For the server, we use Elixir and the Phoenix web framework, with PostgreSQL DB.

Make sure you have these installed:

  * [Elixir](http://elixir-lang.org/install.html) >= 1.3.4
  * [PostgreSQL](https://www.postgresql.org/download/) >= 9.6

To setup your dev environment:

  * Clone this repo and cd into the directory
  * `cp .env.example .env` and fill out the details.
  * Export the env variables with `export $(cat .env | xargs)`
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Setup the data with `mix do benarid.portal.sync --all, benarid.rating.sync`
  * Start the server with `mix phoenix.server`

The server will then be running at [`localhost:4000`](http://localhost:4000)

To run the tests, use:

```
$ mix test
```

## License

The license is still being worked on. Until then, all rights reserved.
