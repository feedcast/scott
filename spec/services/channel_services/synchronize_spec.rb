require "rails_helper"

RSpec.describe ChannelServices::Synchronize do
  let(:service) { ChannelServices::Synchronize.new }

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
      allow(service).to receive(:download).with(channel.feed_url).and_return(feed)
      allow(service).to receive(:synchronize_episodes_with!).and_return(true)
    end

    describe "description" do
      context "when the feed description is present" do
        context "and the channel does not have a description yet" do
          it "updates it" do
            channel.description = nil
            channel.save

            service.call(channel)

            expect(channel.description).to eq("Foo")
          end
        end

        context "and the channel already has a description" do
          it "does not update it" do
            service.call(channel)

            expect(channel.description).to eq("bar")
          end
        end
      end

      context "when the feed description is nil" do
        it "does not updates it" do
          allow(feed).to receive(:description).and_return(nil)

          expect(channel.description).to_not eq(nil)
        end
      end
    end

    describe "image_url" do
      context "when the feed image_url is present" do
        context "and the channel does not have a image_url yet" do
          it "updates it" do
            channel.image_url = nil
            channel.save

            service.call(channel)
            expect(channel.image_url).to eq("http://foo.bar/logo.png")
          end
        end

        context "and the channel already has a image_url" do
          it "does not update it" do
            service.call(channel)

            expect(channel.image_url).to_not eq("http://foo.bar/logo.png")
          end
        end
      end

      context "when the feed image_url is nil" do
        it "does not update it" do
          allow(feed).to receive(:image_url).and_return(nil)

          service.call(channel)

          expect(channel.image_url).to_not be_nil
        end
      end
    end

    describe "site_url" do
      context "when the feed site_link is present" do
        context "and the channel does not have a site_url yet" do
          it "updates it" do
            channel.site_url = nil
            channel.save

            service.call(channel)

            expect(channel.site_url).to eq("http://feedcast.com.br/my-cool-channel")
          end
        end

        context "and the channel already has a site_url" do
          it "does not update it" do
            service.call(channel)

            expect(channel.site_url).to_not eq("http://feedcast.com.br/my-cool-channel")
          end
        end
      end

      context "when the feed site_url is nil" do
        it "does not update it" do
          allow(feed).to receive(:site_url).and_return(nil)

          service.call(channel)

          expect(channel.site_url).to_not eq(nil)
        end
      end
    end

    context "and the channel is not synchronized" do
      let(:channel) { Fabricate(:channel, synchronization_status: :new, synchronized_at: 3.hours.ago) }

      it "triggers the episodes' synchronization" do
        expect(service).to receive(:synchronize_episodes_with!).with(items, channel)

        service.call(channel)
      end

      it "sets the channel status to synchronized" do
        service.call(channel)

        expect(channel.reload).to be_synchronized
      end
    end

    context "and the channel is already synchronized" do
      let(:channel) { Fabricate(:channel, synchronization_status: :success) }

      context "and it is not up to date" do
        let(:channel) { Fabricate(:channel, synchronization_status: :success, synchronized_at: 3.hours.ago) }

        it "triggers the episodes' synchronization" do
          expect(service).to receive(:synchronize_episodes_with!).with(items, channel)

          service.call(channel)
        end

        it "sets the channel status to synchronized" do
          service.call(channel)

          expect(channel.reload).to be_synchronized
        end
      end
    end
  end

  context "when the feed is invalid" do
    let(:channel) { Fabricate(:channel, synchronized_at: 3.hours.ago) }

    before do
      allow(service).to receive(:download)
        .and_raise(ChannelServices::DownloadFeed::InvalidFeed.new("invalid feed"))
    end

    it "does not raise an error" do
      expect { service.call(channel) }.to_not raise_error
    end

    it "sets the channel status to failure" do
      service.call(channel)

      expect(channel).to be_failed
    end

    it "sets the failure message" do
      service.call(channel)

      expect(channel.synchronization_status_message).to include("invalid feed")
    end
  end
end
