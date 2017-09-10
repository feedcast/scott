module EpisodeServices
  class SynchronizeAll
    def call(feed_items, channel)
      return if !any_updates?(feed_items, channel)

      feed_items.each do |episode|
        begin
          synchronize(episode, channel)
        rescue => e
          logger.warn(e)
        end
      end
    end

    private

    def any_updates?(feed_items, channel)
      last_episode = channel.episodes.map(&:published_at).max
      last_item = feed_items.map(&:publish_date).max

      return true if last_episode.nil?
      return false if last_item.nil?

      last_item > last_episode
    end

    def synchronize(episode, channel)
      EpisodeServices::Synchronize.new.call(
        episode.title,
        episode.summary,
        episode.description,
        episode.url,
        episode.publish_date,
        channel
      )
    end

    def logger
      Rails.logger
    end
  end
end
