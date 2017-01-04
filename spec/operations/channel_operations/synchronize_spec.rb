require "rails_helper"

RSpec.describe ChannelOperations::Synchronize, type: :operation do
  let(:channel) { Channel.create(name: "Foo", slug: "foo", feed_url: "foo") }

  context "when the feed is valid" do
    let(:items) do
      [
        double(:item, title: "foo-1", url: "bar-1.mp3", publish_date: Time.parse("01-01-2017 10:10:10")),
        double(:item, title: "foo-2", url: "bar-2.mp3", publish_date: Time.parse("01-01-2017 11:10:10")),
      ]
    end
    let(:feed) { double(:feed, items: items) }

    before do
      allow_any_instance_of(ChannelOperations::Synchronize).to receive(:run).with(ChannelOperations::DownloadFeed, feed_url: channel.feed_url)
                                                                            .and_return(feed)
      allow_any_instance_of(ChannelOperations::Synchronize).to receive(:run).with(EpisodeOperations::Synchronize,
                                                                                  title: items[0].title,
                                                                                  url: items[0].url,
                                                                                  published_at: items[0].publish_date,
                                                                                  channel: channel).and_return(true)
      allow_any_instance_of(ChannelOperations::Synchronize).to receive(:run).with(EpisodeOperations::Synchronize,
                                                                                  title: items[1].title,
                                                                                  url: items[1].url,
                                                                                  published_at: items[1].publish_date,
                                                                                  channel: channel).and_return(true)
    end

    context "and the feed has only valid episodes" do
      it "triggers the episode's synchronization" do
        expect_any_instance_of(ChannelOperations::Synchronize).to receive(:run).with(EpisodeOperations::Synchronize,
                                                                                     title: items[0].title,
                                                                                     url: items[0].url,
                                                                                     published_at: items[0].publish_date,
                                                                                     channel: channel)

        expect_any_instance_of(ChannelOperations::Synchronize).to receive(:run).with(EpisodeOperations::Synchronize,
                                                                                     title: items[1].title,
                                                                                     url: items[1].url,
                                                                                     published_at: items[1].publish_date,
                                                                                     channel: channel)

        run(ChannelOperations::Synchronize, channel: channel)
      end

      it "sets the channel status to synchronized" do
        run(ChannelOperations::Synchronize, channel: channel)

        expect(channel.reload).to be_synchronized
      end
    end

    context "and the feed has invalid episodes" do
      it "sets the channel status to synchronized" do
        allow_any_instance_of(ChannelOperations::Synchronize).to receive(:run).with(EpisodeOperations::Synchronize,
                                                                                    title: items[0].title,
                                                                                    url: items[0].url,
                                                                                    published_at: items[0].publish_date,
                                                                                    channel: channel).and_raise("InvalidEpisode")
        run(ChannelOperations::Synchronize, channel: channel)

        expect(channel).to be_synchronized
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
