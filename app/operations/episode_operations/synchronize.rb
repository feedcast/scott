module EpisodeOperations
  class Synchronize < FunctionalOperations::Operation
    def arguments
      required :title, String
      required :url, String
      required :published_at, Time
      required :channel, Channel
    end

    def perform
      episode = Episode.where(published_at: @published_at, channel_id: @channel.id).first

      if episode.present?
        episode.title = @title
        episode.url = @url

        episode.save!
      else
        Episode.create!(title: @title, url: @url, published_at: @published_at, channel_id: @channel.id)
      end
    end
  end
end
