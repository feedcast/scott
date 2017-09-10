module ChannelServices
  class Synchronize
    def call(channel)
      feed = download(channel.feed_url)

      if feed.description.present? && channel.description.nil?
        channel.description = feed.description
      end

      if feed.image_url.present? && channel.image_url.nil?
        channel.image_url = feed.image_url
      end

      if feed.site_link.present? && channel.site_url.nil?
        channel.site_url = feed.site_link
      end

      synchronize_episodes_with!(feed.items, channel)

      channel.synchronization_success!
    rescue => e
      channel.synchronization_failure!(e.message)
    end

    private

    def download(feed_url)
      ChannelServices::DownloadFeed.new.call(feed_url)
    end

    def synchronize_episodes_with!(items, channel)
      EpisodeServices::SynchronizeAll.new.call(items, channel)
    end
  end
end
