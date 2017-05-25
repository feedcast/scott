class API < Grape::API
  format :json
  formatter :json, Grape::Formatter::ActiveModelSerializers

  rescue_from Mongoid::Errors::DocumentNotFound do
    error!({ message: "not found" }, 404)
  end

  namespace :api do
    mount API::V1
  end
end
