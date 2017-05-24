class API < Grape::API
  format :json
  formatter :json, Grape::Formatter::ActiveModelSerializers

  mount API::V1
end
