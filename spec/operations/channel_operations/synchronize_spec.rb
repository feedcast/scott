require "rails_helper"

RSpec.describe ChannelOperations::Synchronize, type: :operation do
  context "when the feed is valid" do
    let(:channel) { Fabricate(:channel, image_url: "foo.png", description: "bar", site_url: "http://google.com") }
    let(:items) do
      [
        double(:item, publish_date: 1.hour.ago),
        double(:item, publish_date: 1.day.ago),
        double(:item, publish_date: 3.days.ago)
      ]
    end
    let(:feed) do
      double(:feed,
             description: "Foo",
             site_link: "http://feedcast.com.br/my-cool-channel",
             image_url: "http://foo.bar/logo.png",
             items: items)
    end

    before do
      allow_any_instance_of(ChannelOperations::Synchronize).to receive(:run).with(ChannelOperations::DownloadFeed, feed_url: channel.feed_url).and_return(feed)
      allow_any_instance_of(ChannelOperations::Synchronize).to receive(:run).with(EpisodeOperations::SynchronizeAll, channel: channel, feed_items: items).and_return(true)
    end

    context "and the description is present" do
      it "updates it" do
        expect {
          run(ChannelOperations::Synchronize, channel: channel)
        }.to change(channel, :description).from("bar").to("Foo")
      end
    end

    context "and the description is nil" do
      it "does not updates it" do
        allow(feed).to receive(:description).and_return(nil)

        run(ChannelOperations::Synchronize, channel: channel)

        expect(channel.description).to_not be_nil
      end
    end

    context "and the image_url is present" do
      it "updates it" do
        expect {
          run(ChannelOperations::Synchronize, channel: channel)
        }.to change(channel, :image_url).from("foo.png").to(feed.image_url)
      end
    end

    context "and the image_url is nil" do
      it "does not updates it" do
        allow(feed).to receive(:image_url).and_return(nil)

        run(ChannelOperations::Synchronize, channel: channel)

        expect(channel.image_url).to_not be_nil
      end
    end

    context "and the site_url is nil" do
      it "does not updates it" do
        allow(feed).to receive(:site_link).and_return(nil)

        run(ChannelOperations::Synchronize, channel: channel)

        expect(channel.site_url).to_not be_nil
      end
    end

    context "and the site_url is present" do
      it "updates it" do
        expect {
          run(ChannelOperations::Synchronize, channel: channel)
        }.to change(channel, :site_url).from("http://google.com").to(feed.site_link)
      end
    end

    context "and the site_url is nil" do
      it "does not updates it" do
        allow(feed).to receive(:site_link).and_return(nil)

        run(ChannelOperations::Synchronize, channel: channel)

        expect(channel.site_url).to_not be_nil
      end
    end

    context "and the channel is not synchronized" do
      let(:channel) { Fabricate(:channel, synchronization_status: :new, synchronized_at: 3.hours.ago) }

      it "triggers the episodes' synchronization" do
        expect_any_instance_of(ChannelOperations::Synchronize).to receive(:run)
          .with(EpisodeOperations::SynchronizeAll, channel: channel, feed_items: items)

        run(ChannelOperations::Synchronize, channel: channel)
      end

      it "sets the channel status to synchronized" do
        run(ChannelOperations::Synchronize, channel: channel)

        expect(channel.reload).to be_synchronized
      end
    end

    context "and the channel is already synchronized" do
      let(:channel) { Fabricate(:channel, synchronization_status: :success) }

      context "and it is not up to date" do
        let(:channel) { Fabricate(:channel, synchronization_status: :success, synchronized_at: 3.hours.ago) }

        it "triggers the episodes' synchronization" do
          expect_any_instance_of(ChannelOperations::Synchronize).to receive(:run)
            .with(EpisodeOperations::SynchronizeAll, channel: channel, feed_items: items)

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
      allow_any_instance_of(ChannelOperations::DownloadFeed).to receive(:call)
        .and_raise(ChannelOperations::DownloadFeed::InvalidFeed.new("invalid feed"))
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
