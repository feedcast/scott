module EpisodeServices
  class CleanIndex
    def call
      Episode.update_all(indexed_at: nil)
    end
  end
end
