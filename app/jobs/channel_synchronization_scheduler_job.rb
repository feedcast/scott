class ChannelSynchronizationSchedulerJob < ApplicationJob
  queue_as :synchronization

  def perform(*args)
    run(ChannelOperations::ScheduleAll)
  end
end
