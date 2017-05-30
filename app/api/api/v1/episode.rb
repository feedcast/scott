class API::V1::Episode < Grape::API
  namespace :episodes do
    get do
      episodes = ::Episode.all

      { episodes: ::EpisodesSerializer.new(episodes).as_json }
    end

    namespace ":uuid" do
      get do
        episode = ::Episode.find_by(uuid: params[:uuid])

        episode
      end
    end
  end
end
