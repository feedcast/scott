module EpisodeServices
  class IndexOutdated
    def call
      Episode.all.each do |episode|
        if episode.indexed_at.nil? || episode.updated_at > episode.indexed_at
          schedule_indexer_for(episode)
        end
      end
    end

    private

    def schedule_indexer_for(episode)
      EpisodeIndexerJob.perform_later(episode.uuid)
    end
  end
end
