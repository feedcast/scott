class API::V1 < Grape::API
  version :v1, using: :accept_version_header

  mount API::V1::Channel
end
