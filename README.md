# :headphones: Feedcast
> Listen to all your favorite podcasts in the same place

## Setup

It is expected to have already installed Ruby(2.4) and MongoDB or Docker.

Run `make setup` to install the dependencies.

## Showtime

If you are using MongoDB locally, make sure it is already running, otherwise, if you are using docker, run `make compose` to start the Docker containers.

Finally, run `make start` to start the server.

The server will start at `http://localhost:5000` by default.
