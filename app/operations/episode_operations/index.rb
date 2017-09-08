module EpisodeOperations
  class Index < FunctionalOperations::Operation
    def arguments
      required :episode, Episode
    end

    def perform
      SearchIndexRequest.new(@episode.to_json)
    end
  end
end
