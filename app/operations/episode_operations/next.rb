module EpisodeOperations
  class Next < FunctionalOperations::Operation
    def arguments
      required :uuid, String
    end

    def perform
      episode = find(@uuid)

      next_published_for(episode) || sample_from_another_channel_for(episode)
    end

    private

    def find(uuid)
      Episode.includes(:channel).find_by(uuid: uuid)
    end

    def sample_from_another_channel_for(episode)
      Episode.where(:id.ne => episode.id, :channel_id.ne => episode.channel_id).sample
    end

    def next_published_for(episode)
      Episode.where(:id.ne => episode.id,
                    :published_at.gt => episode.published_at,
                    :channel_id => episode.channel.id)
        .order_by(published_at: :asc)
        .first
    end
  end
end
