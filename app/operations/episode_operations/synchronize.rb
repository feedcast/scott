module EpisodeOperations
  class Synchronize < FunctionalOperations::Operation
    def arguments
      required :title, String
      optional :summary, String
      required :description, String
      required :url, String
      required :published_at, Time
      required :channel, Channel
    end

    def perform
      episode = Episode.where(published_at: @published_at, channel_id: @channel.id).first

      if episode.present?
        episode.update!(title: @title,
                        summary: @summary,
                        description: @description,
                        audio: { url: @url })
      else
        Episode.create!(title: @title,
                        summary: @summary,
                        description: @description,
                        audio: { url: @url },
                        published_at: @published_at,
                        channel_id: @channel.id)
      end
    end
  end
end
