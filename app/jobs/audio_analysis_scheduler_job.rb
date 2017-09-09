class AudioAnalysisSchedulerJob < ApplicationJob
  queue_as :analysis

  def perform
    AudioServices::ScheduleAnalysis.new.call
  end
end
