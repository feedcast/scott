class ChannelSynchronizationJob < ApplicationJob
  queue_as :synchronization

  def perform(channel_uuid)
    ChannelServices::Synchronize.new.call(Channel.find_by(uuid: channel_uuid))
  end
end
