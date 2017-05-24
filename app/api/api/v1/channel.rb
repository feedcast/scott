class API::V1::Channel < Grape::API
  namespace :channels do
    get ":uuid" do
      channel = ::Channel.find_by(uuid: params[:uuid])

      channel
    end
  end

  rescue_from Mongoid::Errors::DocumentNotFound do
    error!({ message: "not found" }, 404)
  end
end
