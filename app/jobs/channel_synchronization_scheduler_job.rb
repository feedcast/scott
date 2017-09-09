class ChannelSynchronizationSchedulerJob < ApplicationJob
  queue_as :synchronization

  def perform
    run(ChannelOperations::ScheduleAll)
  end
end
