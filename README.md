# :headphones: Feedcast [![Build Status](https://travis-ci.org/feedcast/core.svg?branch=master)](https://travis-ci.org/marceloboeira/feedcast)
> Listen to all your favorite podcasts in the same place

## Contributing

Please consider reading our [Contribution Guide](CONTRIBUTING.md) before anything else.

## Setup

It is expected to have already installed:

 * Ruby (rbenv/rvm)
 * ffmpeg (background audio analysis)
 * MongoDB
 * Redis
 * Docker (if you don't want to install Mongo/Redis)

If you are in a mac you can install the non-ruby or database dependencies by running `brew bundle`.

Run `make setup` to install the dependencies and set the default environment variables.

Run `make seed` to add sample channels.

### Environment variables

We are currently using [Figaro](https://github.com/laserlemon/figaro) to manage the environment variables.

The variables can be defined at `config/application.yml`  and the default template setup with the list of all variables is available at `config/application.default.yml`.

The command `make setup` already copies the default file template to `config/application.yml`.

## Showtime

If you are using MongoDB locally, make sure it is already running, otherwise, if you are using docker, run `make compose` to start the Docker containers.

Finally, run `make start` to start the server.

The server will start at `http://localhost:5000` by default.

### Admin Area

The application is using [Rails Admin](https://github.com/sferik/rails_admin).

The admin area can be accessed at `http://localhost:5000/admin` by default.

### Experiments

We are running [Split](https://github.com/splitrb/split), an AB testing framework, at `http://localhost:5000/admin/experiments`.

More information available at Split's [official page](https://github.com/splitrb/split).

### Synchronization

In order to synchronize the channels' data with the XML feeds, run: `make synchronize`.
