module ChannelOperations
  class SynchronizeAll < FunctionalOperations::Operation
    def perform
      Channel.all.each do |channel|
        synchronize(channel)
      end
    end

    private

    def synchronize(channel)
      run(ChannelOperations::Synchronize, channel: channel)
    end
  end
end
