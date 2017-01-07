require "rails_helper"

RSpec.describe ChannelOperations::Synchronize, type: :operation do
  context "when the feed is valid" do
    let(:channel) { Fabricate(:channel, image_url: "foo.png") }
    let(:items) do
      [
        double(:item, publish_date: 1.hour.ago),
        double(:item, publish_date: 1.day.ago),
        double(:item, publish_date: 3.days.ago)
      ]
    end
    let(:feed) { double(:feed, image_url: "http://foo.bar/logo.png",items: items) }

    before do
      allow_any_instance_of(ChannelOperations::Synchronize).to receive(:run).with(ChannelOperations::DownloadFeed, feed_url: channel.feed_url).and_return(feed)
      allow_any_instance_of(ChannelOperations::Synchronize).to receive(:run).with(EpisodeOperations::SynchronizeAll, channel: channel, feed_items: items).and_return(true)
    end

    context "and the image_url is present" do
      it "updates it" do
        expect {
          run(ChannelOperations::Synchronize, channel: channel)
        }.to change(channel, :image_url).from("foo.png").to(feed.image_url)
      end
    end

    context "and the image_url is nil" do
      let(:feed) { double(:feed, image_url: nil, items: items) }

      it "does not updates it" do
        run(ChannelOperations::Synchronize, channel: channel)

        expect(channel.image_url).to_not be_nil
      end
    end

    context "and the channel is not synchronized" do
      let(:channel) { Fabricate(:channel, synchronization_status: :new, synchronized_at: 3.hours.ago) }

      it "triggers the episodes' synchronization" do
        expect_any_instance_of(ChannelOperations::Synchronize).to receive(:run).with(EpisodeOperations::SynchronizeAll, channel: channel, feed_items: items)

        run(ChannelOperations::Synchronize, channel: channel)
      end

      it "sets the channel status to synchronized" do
        run(ChannelOperations::Synchronize, channel: channel)

        expect(channel.reload).to be_synchronized
      end
    end

    context "and the channel is already synchronized" do
      let(:channel) { Fabricate(:channel, synchronization_status: :success) }

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
        let(:channel) { Fabricate(:channel, synchronization_status: :success, synchronized_at: Time.now) }

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
        let(:channel) { Fabricate(:channel, synchronization_status: :success, synchronized_at: 3.hours.ago) }

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
  end

  context "when the feed is invalid" do
    let(:channel) { Fabricate(:channel, synchronized_at: 3.hours.ago) }

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
