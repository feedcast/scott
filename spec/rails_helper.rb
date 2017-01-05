ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)

abort("The Rails environment is running in production mode!") if Rails.env.production?

require "spec_helper"
require "rspec/rails"

RSpec.configure do |config|
  config.filter_rails_from_backtrace!
end
