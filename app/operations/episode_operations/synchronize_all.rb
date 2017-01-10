module EpisodeOperations
  class SynchronizeAll < FunctionalOperations::Operation
    def arguments
      required :channel, Channel
      required :feed_items, Array
    end

    def perform
      return unless @feed_items.size > 0

      @feed_items.each do |episode|
        begin
          synchronize(episode, @channel)
        rescue => e
          logger.warn(e)
        end
      end
    end

    private

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
