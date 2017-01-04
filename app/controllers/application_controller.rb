class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from Mongoid::Errors::DocumentNotFound do
    head :not_found
  end
end
