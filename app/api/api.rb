class API < Grape::API
  format :json
  formatter :json, Grape::Formatter::ActiveModelSerializers

  rescue_from Mongoid::Errors::DocumentNotFound do
    error!({ message: "not found" }, 404)
  end

  before do
    header("Access-Control-Expose-Headers", "total")
    header("Access-Control-Allow-Origin", "*")
  end

  mount API::V1
end
