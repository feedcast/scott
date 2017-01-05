.PHONY: default
default: setup

.PHONY: setup
setup:
	bin/bundle install

.PHONY: start
start:
	bin/rails server -b 127.0.0.1 -p 5000
