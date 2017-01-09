.PHONY: default
default: setup

.PHONY: setup
setup:
	bin/bundle install
	cp config/application.default.yml config/application.yml

.PHONY: seed
seed:
	bin/rake db:seed

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

.PHONY: deploy
deploy:
	git push heroku master

.PHONY: deploy_beta
deploy_beta:
	git push heroku-beta master
