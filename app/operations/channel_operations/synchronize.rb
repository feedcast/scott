module ChannelOperations
  class Synchronize < FunctionalOperations::Operation
    def arguments
      required :channel, Channel
    end

    def perform
      @feed = download_feed_for(@channel)

      @channel.image_url = @feed.image_url unless @feed.image_url.nil?

      synchronize_episodes_with!(@feed.items, @channel) if ready_to_synchronize?(@channel, @feed)

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

    def ready_to_synchronize?(channel, feed)
      !channel.synchronized? || available_updates?(feed, channel)
    end

    def available_updates?(feed, channel)
      feed.items.map(&:publish_date).max > channel.synchronized_at
    end
  end
end
