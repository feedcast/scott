class ChannelSynchronizationJob < ApplicationJob
  queue_as :synchronization

  def perform(channel_uuid)
    run(ChannelOperations::Synchronize, channel: Channel.find_by(uuid: channel_uuid))
  end
end
