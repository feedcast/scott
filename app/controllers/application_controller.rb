class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  http_basic_authenticate_with name: ENV["FEEDCAST_HTTP_AUTH_USER"], password: ENV["FEEDCAST_HTTP_AUTH_PASSWORD"] if Rails.env.beta?

  rescue_from Mongoid::Errors::DocumentNotFound do
    render "errors/404", status: :not_found
  end
end
