class ChannelSynchronizationSchedulerJob < ApplicationJob
  queue_as :synchronization

  def perform
    ChannelServices::ScheduleSynchronization.new.call
  end
end
