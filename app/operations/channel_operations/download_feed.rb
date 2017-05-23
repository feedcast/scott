require "house.rb"

module ChannelOperations
  class DownloadFeed < FunctionalOperations::Operation
    class InvalidFeed < StandardError; end

    def arguments
      required :feed_url, String
    end

    def perform
      @feed = House::Podcast.new(@feed_url)
    rescue => e
      raise InvalidFeed, "#{@feed_url} is not a valid xml feed: #{e.message}"
    end
  end
end
