require "sidekiq/web"
require "sidekiq-scheduler/web"

Sidekiq::Web.set(:session_secret, Rails.application.secrets[:secret_key_base])
Sidekiq::Web.set(:sessions, Rails.application.config.session_options)

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  user == ENV["FEEDCAST_HTTP_AUTH_USER"] && password == ENV["FEEDCAST_HTTP_AUTH_PASSWORD"]
end

Sidekiq.configure_server do |config|
  config.failures_max_count = false
end
