module ChannelOperations
  class Index < FunctionalOperations::Operation
    def arguments
      required :channel, Channel
    end

    def perform
      # Put request to Scully with @channel.to_json
    end
  end
end
