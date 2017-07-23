class ApplicationController < ActionController::Base
  before_action :ensure_cookie!
  protect_from_forgery with: :exception

  http_basic_authenticate_with name: ENV.fetch("FEEDCAST_HTTP_AUTH_USER", "admin"),
                               password: ENV.fetch("FEEDCAST_HTTP_AUTH_PASSWORD", "admin") if Rails.env.beta?

  rescue_from Mongoid::Errors::DocumentNotFound do
    render "errors/404", status: :not_found
  end

  private

  def ensure_cookie!
    # Creates a permanent fake user id while we don't have logged users
    cookies[:user_id] ||= {
      value: SecureRandom.uuid,
      expires: 10.years.from_now,
      domain: :all
    }
  end

  def user_id
    cookies[:user_id]
  end
end
