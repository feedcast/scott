class API::V1::Episode < Grape::API
  include Grape::Rails::Cache

  namespace :episodes do
    paginate per_page: 10
    get do
      page, per_page = params[:page], params[:per_page]
      cache(key: "api:episodes:list:#{page}:#{per_page}", expires_in: 5.minutes) do
        episodes = paginate(::Episode.all.order(created_at: :desc))

        { episodes: ::EpisodesSerializer.new(episodes).as_json }
      end
    end

    route_param :uuid do
      get do
        uuid = params[:uuid]
        cache(key: "api:episodes:#{uuid}", expires_in: 30.days) do
          episode = ::Episode.find_by(uuid: uuid)

          EpisodeSerializer.new(episode)
        end
      end
    end
  end
end
