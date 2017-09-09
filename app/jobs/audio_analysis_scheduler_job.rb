class AudioAnalysisSchedulerJob < ApplicationJob
  queue_as :analysis

  def perform
    run(AudioOperations::ScheduleAll)
  end
end
