module AudioOperations
  class ScheduleAll < FunctionalOperations::Operation
    def perform
      Episode.not_analysed.order_by(published_at: :desc).each do |episode|
        schedule_analysis_for(episode.audio)
      end
    end

    private

    def schedule_analysis_for(audio)
      AudioAnalysisJob.perform_later(audio.episode.uuid)
    end
  end
end
