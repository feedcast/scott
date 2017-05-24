class API::V1::Channel < Grape::API
  namespace :channels do
    get ":uuid" do
      channel = ::Channel.find_by(uuid: params[:uuid])

      channel
    end
  end
end
