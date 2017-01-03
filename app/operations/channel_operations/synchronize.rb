module ChannelOperations
  class Synchronize < FunctionalOperations::Operation
    def arguments
      required :channel, Channel
    end

    def perform
      @feed = download_feed_for(@channel)

      @feed.items.each do |item|
        episode = Episode.where(published_at: item.publish_date, channel_id: @channel.id).first

        if episode.present?
          episode.title = item.title
          episode.url = item.url
          episode.save
        else
          Episode.create(title: item.title,
                         url: item.url,
                         published_at: item.publish_date,
                         channel_id: @channel.id)
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
  end
end
