class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from Mongoid::Errors::DocumentNotFound do |exception|
    head :not_found
  end
end
