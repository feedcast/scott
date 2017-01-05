require "rails_helper"

RSpec.describe ChannelOperations::Synchronize, type: :operation do
  let(:channel) { Channel.create(title: "Foo", feed_url: "foo") }

  context "when the feed is valid" do
    let(:items) do
      [
        double(:item, publish_date: 1.hour.ago),
        double(:item, publish_date: 1.day.ago),
        double(:item, publish_date: 3.days.ago)
      ]
    end
    let(:feed) { double(:feed, items: items) }

    before do
      allow_any_instance_of(ChannelOperations::Synchronize).to receive(:run).with(ChannelOperations::DownloadFeed, feed_url: channel.feed_url).and_return(feed)
      allow_any_instance_of(ChannelOperations::Synchronize).to receive(:run).with(EpisodeOperations::SynchronizeAll, channel: channel, feed_items: items).and_return(true)
    end

    context "and it has no items" do
      let(:items) do
        []
      end

      it "does not trigger the episodes' synchronization" do
        expect_any_instance_of(ChannelOperations::Synchronize).to_not receive(:run).with(EpisodeOperations::SynchronizeAll, channel: channel, feed_items: items)

        run(ChannelOperations::Synchronize, channel: channel)
      end

      it "sets the channel status to synchronized" do
        run(ChannelOperations::Synchronize, channel: channel)

        expect(channel.reload).to be_synchronized
      end
    end

    context "and it already is up to date" do
      let(:channel) { Channel.create(title: "Foo", feed_url: "foo", synchronized_at: Time.now) }

      it "does not trigger the episodes' synchronization" do
        expect_any_instance_of(ChannelOperations::Synchronize).to_not receive(:run).with(EpisodeOperations::SynchronizeAll, channel: channel, feed_items: items)

        run(ChannelOperations::Synchronize, channel: channel)
      end

      it "sets the channel status to synchronized" do
        run(ChannelOperations::Synchronize, channel: channel)

        expect(channel.reload).to be_synchronized
      end
    end

    context "and it is not up to date" do
      let(:channel) { Channel.create(title: "Foo", feed_url: "foo", synchronized_at: 3.hours.ago) }

      it "triggers the episodes' synchronization" do
        expect_any_instance_of(ChannelOperations::Synchronize).to receive(:run).with(EpisodeOperations::SynchronizeAll, channel: channel, feed_items: items)

        run(ChannelOperations::Synchronize, channel: channel)
      end

      it "sets the channel status to synchronized" do
        run(ChannelOperations::Synchronize, channel: channel)

        expect(channel.reload).to be_synchronized
      end
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
