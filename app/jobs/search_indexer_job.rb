class SearchIndexerJob < ApplicationJob
  queue_as :index

  def perform(channel_uuid)
    run(ChannelOperations::Index, channel: Channel.find_by(uuid: channel_uuid))
  end
end
