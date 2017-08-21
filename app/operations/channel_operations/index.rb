module ChannelOperations
  class Index < FunctionalOperations::Operation
    def arguments
      required :channel, Channel
    end

    def perform
      SearchIndexRequest.new(@channel.to_json)
    end
  end
end
