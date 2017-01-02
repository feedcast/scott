module ChannelOperations
  class Synchronize < FunctionalOperations::Operation
    def arguments
      required :channel, Channel
    end

    def perform
      @feed = download_feed_for(@channel)

      @feed.items.each do |item|
        episode = @channel.episodes.where(published_at: item.publish_date).first

        if episode.present?
          episode.title = item.title
          episode.save
        else
          @channel.episodes.create!(title: item.title,
                                    url: item.url,
                                    published_at: item.publish_date)
        end
      end
    end

    private

    def download_feed_for(channel)
      run(ChannelOperations::DownloadFeed, feed_url: channel.feed_url)
    end
  end
end
