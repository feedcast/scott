module ChannelServices
  class ScheduleSynchronization
    def call
      Channel.all.each do |channel|
        schedule_sync_for(channel)
      end
    end

    private

    def schedule_sync_for(channel)
      ChannelSynchronizationJob.perform_later(channel.uuid)
    end
  end
end
