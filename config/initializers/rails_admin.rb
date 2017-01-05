RailsAdmin.config do |config|
  config.authenticate_with do
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["FEEDCAST_HTTP_AUTH_USER"] && password == ENV["FEEDCAST_HTTP_AUTH_PASSWORD"]
    end
  end
  
  config.actions do
    dashboard
    index
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
  end
end
