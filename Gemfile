source "https://rubygems.org"
ruby "2.4.1"

gem "rails", "~> 5.0.1"

# API
gem "grape"
gem "grape-active_model_serializers"

# Server
gem "puma", "~> 3.0"

# Operations
gem "functional_operations"

# Database
gem "mongoid", "~> 6.0.0"
gem "mongoid-uuid"
gem "mongoid-slug"

# Validators
gem "date_validator"

# Pagination
gem "kaminari"
gem "kaminari-mongoid"
gem "kaminari-actionview"

# Decorator
gem "draper", git: "https://github.com/drapergem/draper"

# Admin
gem "rails_admin", "~> 1.0"

# I18n
gem "rails-i18n"
gem "rails_admin-i18n"

# Environment Variables
gem "figaro"

# Log and Monitoring
gem "newrelic_rpm"
gem "rollbar"

# Podcast RSS Feeds
gem "house.rb", ">= 0.1.1"

# Audio analysis
gem "streamio-ffmpeg"

# AB Testing
gem "redis"
gem "split"

# Sanitize
gem "sanitize"

# Summary processing
gem "rails_autolink"

# SEO
gem "meta-tags"

# Assets
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"

source "https://rails-assets.org" do
  gem "rails-assets-bootstrap"
  gem "rails-assets-fontawesome", "~> 4.7.0"
  gem "rails-assets-feedcast-player", "~> 0.0.14"
end

group :development, :test do
  # Guard
  gem "guard-bundler", require: false
  gem "guard-rspec", require: false

  # RSpec
  gem "rspec-rails", "~> 3.5"

  # Rack Server
  gem "sinatra", "2.0.0"
  gem "sham_rack"

  # Test Support
  gem "fabrication"
  gem "faker"
  gem "database_cleaner"

  # Feature tests
  gem "capybara"
  gem "selenium-webdriver"

  # Coverage
  gem "simplecov"
  gem "codeclimate-test-reporter", "~> 1.0.0"

  # Debug
  gem "byebug", platform: :mri
end

group :development do
  gem "web-console", ">= 3.3.0"
  gem "listen", "~> 3.0.5"
end
