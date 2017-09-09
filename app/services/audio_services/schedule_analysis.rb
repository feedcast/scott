module AudioServices
  class ScheduleAnalysis
    def call
      Episode.not_analysed.each do |episode|
        schedule_analysis_for(episode.audio)
      end
    end

    private

    def schedule_analysis_for(audio)
      AudioAnalysisJob.perform_later(audio.episode.uuid)
    end
  end
end
