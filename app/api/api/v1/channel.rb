class API::V1::Channel < Grape::API
  namespace :channels do
    paginate per_page: 10
    get do
      channels = paginate(::Channel.all)

      { channels: ::ChannelsSerializer.new(channels).as_json }
    end

    route_param :uuid do
      get do
        channel = ::Channel.find_by(uuid: params[:uuid])

        channel
      end

      paginate per_page: 10
      get :episodes do
        episodes = paginate(::Channel.find_by(uuid: params[:uuid]).episodes.order(created_at: :desc))

        { episodes: ::EpisodesSerializer.new(episodes).as_json }
      end
    end
  end
end
