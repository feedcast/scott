module EpisodeOperations
  class SynchronizeAll < FunctionalOperations::Operation
    def arguments
      required :channel, Channel
      required :feed_items, Array
    end

    def perform
      return if !any_updates?

      @feed_items.each do |episode|
        begin
          synchronize(episode, @channel)
        rescue => e
          logger.warn(e)
        end
      end
    end

    private

    def any_updates?
      last_episode = @channel.episodes.map(&:published_at).max
      last_item = @feed_items.map(&:publish_date).max

      return true if last_episode.nil?
      return false if last_item.nil?

      last_item > last_episode
    end

    def synchronize(episode, channel)
      run(EpisodeOperations::Synchronize,
          title: episode.title,
          summary: episode.summary,
          description: episode.description,
          url: episode.url,
          published_at: episode.publish_date,
          channel: channel)
    end

    def logger
      Rails.logger
    end
  end
end
