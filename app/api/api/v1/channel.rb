class API::V1::Channel < Grape::API
  namespace :channels do
    get do
      channels = ::Channel.all

      { channels: ::ChannelsSerializer.new(channels).as_json }
    end

    get ":uuid" do
      channel = ::Channel.find_by(uuid: params[:uuid])

      channel
    end
  end
end
