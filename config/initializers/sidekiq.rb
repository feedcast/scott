require "sidekiq/web"
require "sidekiq-scheduler/web"

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  user == ENV["FEEDCAST_HTTP_AUTH_USER"] && password == ENV["FEEDCAST_HTTP_AUTH_PASSWORD"]
end
