class API::V1::Episode < Grape::API
  include Grape::Rails::Cache

  namespace :episodes do
    paginate per_page: 10
    get do
      page, per_page = params[:page], params[:per_page]

      cache(key: "api:episodes:list:#{page}:#{per_page}", expires_in: 5.minutes) do
        episodes = paginate(::Episode.all.order(published_at: :desc))

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


      namespace :next do
        params do
          requires :amount, type: Integer, values: (1..10).to_a
        end
        route_param :amount do
          get do
            uuid, amount = params[:uuid], params[:amount]

            cache(key: "api:episodes:#{uuid}:next:#{amount}", expires_in: 6.hours) do
              episode = Episode.find_by!(uuid: uuid)
              episodes = EpisodeOperations::Next.new.call(episode: episode, amount: amount)

              { episodes: ::EpisodesSerializer.new(episodes).as_json }
            end
          end
        end
      end
    end
  end
end
