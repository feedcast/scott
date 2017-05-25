# :headphones: Feedcast [![Build Status](https://travis-ci.org/feedcast/core.svg?branch=master)](https://travis-ci.org/feedcast/core) [![Code Climate](https://codeclimate.com/github/marceloboeira/feedcast/badges/gpa.svg)](https://codeclimate.com/github/marceloboeira/feedcast) [![Test Coverage](https://codeclimate.com/github/marceloboeira/feedcast/badges/coverage.svg)](https://codeclimate.com/github/marceloboeira/feedcast/coverage)
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

To stop the docker compose daemon safely (without destroying the instances), use `make decompose`

To run the console, use `make console`

### Admin Area

The application is using [Rails Admin](https://github.com/sferik/rails_admin).

The admin area can be accessed at `http://localhost:5000/admin` by default.

### Experiments

We are running [Split](https://github.com/splitrb/split), an AB testing framework, at `http://localhost:5000/admin/experiments`.

More information available at Split's [official page](https://github.com/splitrb/split).

### Asynchronous taks

**Important**

On an ideal scenario we would have a stream-like pipeline to manage the asynchronous tasks, meaning that everytime a new channel is created it would trigget its own sychronization, the same is valid for episodes and audios. However, given the current aspects of our infrastructure, it makes more sense to use a "cron task" approach, because it is cheaper and it serve its purpose. Either way our operations are prepared to the switch since the conception, if at some point we need to create a more "real-time" pipeline it is not difficult.

#### Synchronization

In order to synchronize the channels' data with the XML feeds, run: `make synchronize`.

That will sequentially download and process all the XML RSS feeds, creating new episodes or updating the existing ones.

The task takes a while to run if there are lots of channels, grab a chair.

#### Audio Analysis

In order to analyse the episodes' audio info with the real audio files, run: `make analyse`.

That will sequentially download and process all the audio files, adding information like codec, duration, size, sample rate, bitrate and more.

The task takes a while to run, but it is limited to 100 audio files per run, it prioritizes the last published episodes always.
