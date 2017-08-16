module ChannelOperations
  class IndexAllOutdated < FunctionalOperations::Operation
    def perform
      Channel.all.each do |channel|
        if channel.indexed_at.nil? || channel.updated_at > channel.indexed_at
          schedule_indexer_for(channel)
        end
      end
    end

    private

    def schedule_indexer_for(channel)
      SearchIndexerJob.perform_later(channel.uuid)
    end
  end
end
