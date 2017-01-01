source "https://rubygems.org"

gem "rails", "~> 5.0.1"

# Server
gem "puma", "~> 3.0"

# Assets
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"

# Database
gem "mongoid", "~> 6.0.0"
gem "mongoid-uuid", git: "https://github.com/marceloboeira/mongoid-uuid"

# Operations
gem "functional_operations"

# Admin
gem "rails_admin", "~> 1.0"

# XML Feed
gem "nokogiri"
gem "podcast_reader", git: "https://github.com/kule/podcast_reader"

group :development, :test do
  gem "rspec-rails", "~> 3.5"
  gem "guard-rails", require: false
  gem "guard-rspec", require: false
  gem "guard-bundler", require: false
  gem "capybara"
  gem "database_cleaner"
  gem "byebug", platform: :mri
end

group :development do
  gem "web-console", ">= 3.3.0"
  gem "listen", "~> 3.0.5"
end
