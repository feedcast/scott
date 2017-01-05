module ChannelOperations
  class Synchronize < FunctionalOperations::Operation
    def arguments
      required :channel, Channel
    end

    def perform
      @feed = download_feed_for(@channel)

      synchronize_episodes_with!(@feed.items, @channel) if available_updates?(@feed, @channel)

      @channel.synchronization_success!
    rescue => e
      @channel.synchronization_failure!(e.message)
    end

    private

    def download_feed_for(channel)
      run(ChannelOperations::DownloadFeed, feed_url: channel.feed_url)
    end

    def synchronize_episodes_with!(items, channel)
      run(EpisodeOperations::SynchronizeAll, feed_items: items, channel: channel)
    end

    def available_updates?(feed, channel)
      return false if feed.items.empty?

      feed.items.map(&:publish_date).max > channel.synchronized_at
    end
  end
end
