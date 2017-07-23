class API::V1::Episode < Grape::API
  namespace :episodes do
    paginate per_page: 10
    get do
      episodes = paginate(::Episode.all.order(created_at: :desc))

      { episodes: ::EpisodesSerializer.new(episodes).as_json }
    end

    route_param :uuid do
      get do
        episode = ::Episode.find_by(uuid: params[:uuid])

        episode
      end
    end
  end
end
