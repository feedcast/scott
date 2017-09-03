class API::V1::Channel < Grape::API
  include Grape::Rails::Cache

  namespace :channels do
    paginate per_page: 10
    get do
      page, per_page = params[:page], params[:per_page]

      cache(key: "api:channels:list:#{page}:#{per_page}", expires_in: 10.minutes) do
        channels = paginate(::Channel.all.order(created_at: :desc))

        { channels: ::ChannelsSerializer.new(channels).as_json }
      end
    end

    route_param :slug do
      get do
        slug = params[:slug]

        cache(key: "api:channels:#{slug}", expires_in: 1.hour) do
          channel = ::Channel.find(slug)

          ChannelSerializer.new(channel)
        end
      end

      paginate per_page: 10
      get :episodes do
        slug, page, per_page = params[:slug], params[:page], params[:per_page]

        cache(key: "api:channels:#{slug}:episodes:list:#{page}:#{per_page}", expires_in: 10.minutes) do
          episodes = paginate(::Channel.find(slug).episodes.order(published_at: :desc))

          { episodes: ::EpisodesSerializer.new(episodes).as_json }
        end
      end
    end
  end
end
