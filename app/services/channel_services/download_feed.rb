require "house.rb"

module ChannelServices
  class DownloadFeed
    class InvalidFeed < StandardError; end

    def call(feed_url)
      feed = House::Podcast.new(feed_url)
    rescue => e
      raise InvalidFeed, "#{feed_url} is not a valid xml feed: #{e.message}"
    end
  end
end
