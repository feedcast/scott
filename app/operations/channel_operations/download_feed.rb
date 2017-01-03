require "podcast_reader"

module ChannelOperations
  class DownloadFeed < FunctionalOperations::Operation
    class InvalidFeed < StandardError; end

    def arguments
      required :feed_url, String
    end

    def perform
      @feed = PodcastReader.new(@feed_url)
    rescue => e
      raise InvalidFeed.new("#{@feed_url} is not a valid xml feed")
    end
  end
end
