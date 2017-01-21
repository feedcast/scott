module EpisodeOperations
  class AnalyseAll < FunctionalOperations::Operation
    LIMIT_PER_RUN = 25

    def perform
      Episode.not_analysed.limit(LIMIT_PER_RUN).each do |episode|
        analyse!(episode.audio)
      end
    end

    def analyse!(audio)
      run(AudioOperations::Analyse, audio: audio)
    end
  end
end
