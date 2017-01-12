module ChannelOperations
  class Synchronize < FunctionalOperations::Operation
    def arguments
      required :channel, Channel
    end

    def perform
      @feed = download_feed_for(@channel)

      @channel.description = @feed.description unless @feed.description.nil?
      @channel.image_url = @feed.image_url unless @feed.image_url.nil?
      @channel.site_url = @feed.site_link unless @feed.site_link.nil?

      synchronize_episodes_with!(@feed.items, @channel)

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
  end
end
