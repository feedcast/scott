module EpisodeServices
  class Synchronize
    def call(title, summary, description, url, published_at, channel)
      episode = Episode.where(published_at: published_at, channel_id: channel.id).first

      if episode.present?
        episode.update!(title: title,
                        summary: summary,
                        description: description,
                        audio: { url: url })
      else
        Episode.create!(title: title,
                        summary: summary,
                        description: description,
                        audio: { url: url },
                        published_at: published_at,
                        channel_id: channel.id)
      end
    end
  end
end
