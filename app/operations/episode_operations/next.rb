module EpisodeOperations
  class Next < FunctionalOperations::Operation
    def arguments
      required :episode, Episode
      required :amount, Integer
    end

    def perform
      episodes = []
      episode = @episode

      @amount.times do
        episode = next_published_for(episode) || sample_from_another_channel_for(episode)
        episodes << episode unless episode.nil?
      end

      episodes
    end

    private

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
