require "rails_helper"

RSpec.describe ChannelOperations::Synchronize, type: :operation do
  let(:channel) { Channel.create(name: "Foo", slug: "foo", feed_url: "foo") }

  context "when the feed is valid" do
    let(:items) { double(:items) }
    let(:feed) { double(:feed, items: items) }

    before do
      allow_any_instance_of(ChannelOperations::Synchronize).to receive(:run).with(ChannelOperations::DownloadFeed, feed_url: channel.feed_url).and_return(feed)
      allow_any_instance_of(ChannelOperations::Synchronize).to receive(:run).with(EpisodeOperations::SynchronizeAll, channel: channel, feed_items: items).and_return(true)
    end

    it "triggers the episodes' synchronization" do
      expect_any_instance_of(ChannelOperations::Synchronize).to receive(:run).with(EpisodeOperations::SynchronizeAll, channel: channel, feed_items: items)

      run(ChannelOperations::Synchronize, channel: channel)
    end

    it "sets the channel status to synchronized" do
      run(ChannelOperations::Synchronize, channel: channel)

      expect(channel.reload).to be_synchronized
    end
  end

  context "when the feed is invalid" do
    before do
      allow_any_instance_of(ChannelOperations::DownloadFeed).to receive(:call).and_raise(ChannelOperations::DownloadFeed::InvalidFeed.new("invalid feed"))
    end

    it "does not raise an error" do
      expect {
        run(ChannelOperations::Synchronize, channel: channel)
      }.to_not raise_error
    end

    it "sets the channel status to failure" do
      run(ChannelOperations::Synchronize, channel: channel)

      expect(channel).to be_failed
    end

    it "sets the failure message" do
      run(ChannelOperations::Synchronize, channel: channel)

      expect(channel.synchronization_status_message).to include("invalid feed")
    end
  end
end
