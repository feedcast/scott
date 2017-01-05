module EpisodeOperations
  class Synchronize < FunctionalOperations::Operation
    def arguments
      required :title, String
      required :description, String
      required :url, String
      required :published_at, Time
      required :channel, Channel
    end

    def perform
      episode = Episode.where(published_at: @published_at, channel_id: @channel.id).first

      if episode.present?
        episode.update!(title: @title,
                        description: @description,
                        url: @url)
      else
        Episode.create!(title: @title,
                        description: @description,
                        url: @url,
                        published_at: @published_at,
                        channel_id: @channel.id)
      end
    end
  end
end
