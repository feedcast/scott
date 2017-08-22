.PHONY: default
default: install

.PHONY: install
install:
	gem install foreman
	bin/bundle install
	cp config/application.default.yml config/application.yml

.PHONY: seed
seed:
	bin/rake db:seed

.PHONY: start
start:
	foreman start

.PHONY: web
web:
	bin/puma -C config/puma.rb

.PHONY: worker
worker:
	bin/sidekiq -C config/sidekiq.yml

.PHONY: console
console:
	bin/rails console

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

.PHONY: deploy
deploy:
	git push heroku master

.PHONY: deploy_beta
deploy_beta:
	git push heroku-beta master

.PHONY: compose
compose:
	docker-compose up -d

.PHONY: decompose
decompose:
	docker-compose stop
