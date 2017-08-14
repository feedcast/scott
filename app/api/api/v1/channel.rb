class API::V1::Channel < Grape::API
  include Grape::Rails::Cache

  namespace :channels do
    paginate per_page: 10
    get do
      page, per_page = params[:page], params[:per_page]

      cache(key: "api:channels:list:#{page}:#{per_page}", expires_in: 10.minutes) do
        channels = paginate(::Channel.all)

        { channels: ::ChannelsSerializer.new(channels).as_json }
      end
    end

    route_param :uuid do
      get do
        uuid = params[:uuid]

        cache(key: "api:channels:#{uuid}", expires_in: 1.hour) do
          channel = ::Channel.find_by(uuid: uuid)

          ChannelSerializer.new(channel)
        end
      end

      paginate per_page: 10
      get :episodes do
        uuid, page, per_page = params[:uuid], params[:page], params[:per_page]

        cache(key: "api:channels:#{uuid}:episodes:list:#{page}:#{per_page}", expires_in: 10.minutes) do
          episodes = paginate(::Channel.find_by(uuid: uuid).episodes.order(created_at: :desc))

          { episodes: ::EpisodesSerializer.new(episodes).as_json }
        end
      end
    end
  end
end
