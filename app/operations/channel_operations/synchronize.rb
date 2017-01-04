module ChannelOperations
  class Synchronize < FunctionalOperations::Operation
    def arguments
      required :channel, Channel
    end

    def perform
      @feed = download_feed_for(@channel)

      @feed.items.each do |episode|
        begin
          synchronize(episode, @channel)
        rescue => e
          # Ignore invalid episodes
        end
      end

      @channel.synchronization_success!
    rescue => e
      @channel.synchronization_failure!(e.message)
    end

    private

    def download_feed_for(channel)
      run(ChannelOperations::DownloadFeed, feed_url: channel.feed_url)
    end

    def synchronize(episode, channel)
      run(EpisodeOperations::Synchronize, title: episode.title, url: episode.url, published_at: episode.publish_date, channel: channel)
    end
  end
end
