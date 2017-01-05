require "split/dashboard"

Split.configure do |config|
  config.db_failover = true

  config.persistence = :cookie
  config.redis = Redis.current
end

Split::Dashboard.use Rack::Auth::Basic do |username, password|
  username == ENV["FEEDCAST_HTTP_AUTH_USER"] && password == ENV["FEEDCAST_HTTP_AUTH_PASSWORD"]
end
