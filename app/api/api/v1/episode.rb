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

    route_param :channel_slug do
      route_param :episode_slug do
        get do
          channel_slug, episode_slug = params[:channel_slug], params[:episode_slug]

          cache(key: "api:episodes:#{channel_slug}:#{episode_slug}", expires_in: 30.days) do
            episode = ::Episode.find_for(channel_slug, episode_slug)

            EpisodeSerializer.new(episode)
          end
        end

        namespace :next do
          params do
            requires :amount, type: Integer, values: (1..10).to_a
          end
          route_param :amount do
            get do
              channel_slug, episode_slug, amount = params[:channel_slug], params[:episode_slug], params[:amount]

              cache(key: "api:episodes:#{channel_slug}:#{episode_slug}:next:#{amount}", expires_in: 1.day) do
                episode = Episode.find_for(channel_slug, episode_slug)
                episodes = EpisodeOperations::Next.new.call(episode: episode, amount: amount)

                { episodes: ::EpisodesSerializer.new(episodes).as_json }
              end
            end
          end
        end
      end
    end
  end
end
