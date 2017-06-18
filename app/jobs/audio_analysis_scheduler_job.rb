class AudioAnalysisSchedulerJob < ApplicationJob
  queue_as :analysis

  def perform(*args)
    run(AudioOperations::ScheduleAll)
  end
end
