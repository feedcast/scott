.PHONY: default
default: setup

.PHONY: setup
setup:
	bin/bundle install

.PHONY: start
start:
	bin/rails server -b 127.0.0.1 -p 5000

.PHONY: spec
spec:
	bin/rspec

.PHONY: test
test: spec

.PHONY: synchronize
synchronize:
	bin/rake channels:synchronize
