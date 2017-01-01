require "podcast_reader"

module ChannelOperations
  class Synchronize < FunctionalOperations::Operation
  class InvalidFeed < Exception; end
    def arguments
      required :channel, Channel
    end

    def perform
      @podcast = PodcastReader.new(@channel.feed_url)

      @podcast.items.each do |item|
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
    rescue RuntimeError => e
      raise InvalidFeed.new("#{@channel.feed_url} is not a valid xml feed")
    end
  end
end
