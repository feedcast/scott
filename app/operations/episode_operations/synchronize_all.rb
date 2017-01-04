module EpisodeOperations
  class SynchronizeAll < FunctionalOperations::Operation
    def arguments
      required :channel, Channel
      required :feed_items, Array
    end

    def perform
      @feed_items.each do |episode|
        begin
          synchronize(episode, @channel)
        rescue => e
          # Ignore invalid episodes
        end
      end
    end

    private

    def synchronize(episode, channel)
      run(EpisodeOperations::Synchronize, title: episode.title, url: episode.url, published_at: episode.publish_date, channel: channel)
    end
  end
end
