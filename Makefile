.PHONY: default
default: setup

.PHONY: setup
setup:
	bin/bundle install
	cp config/application.default.yml config/application.yml

.PHONY: start
start:
	bin/puma -C config/puma.rb

.PHONY: spec
spec:
	bin/rspec

.PHONY: test
test: spec

.PHONY: report_coverage
report_coverage:
	bin/bundle exec codeclimate-test-reporter

.PHONY: guard
guard:
	bin/guard

.PHONY: synchronize
synchronize:
	bin/rake with:logger channels:synchronize
