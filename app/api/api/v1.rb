class API::V1 < Grape::API
  version :v1, using: :accept_version_header

  mount API::V1::Channel
  mount API::V1::Episode
  mount API::V1::Category
end
