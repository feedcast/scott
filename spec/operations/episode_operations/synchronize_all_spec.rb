require "rails_helper"

RSpec.describe EpisodeOperations::SynchronizeAll, type: :operation do
  let(:channel) { Channel.create(name: "Foo", slug: "foo", feed_url: "foo") }

  let(:items) do
    [
      double(:item, title: "foo-1", url: "bar-1.mp3", publish_date: Time.parse("01-01-2017 10:10:10")),
      double(:item, title: "foo-2", url: "bar-2.mp3", publish_date: Time.parse("01-01-2017 11:10:10")),
    ]
  end

  before do
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

  context "when the feed has only valid episodes" do
    it "triggers each episode's synchronization" do
      expect_any_instance_of(EpisodeOperations::SynchronizeAll).to receive(:run).with(EpisodeOperations::Synchronize,
                                                                                      title: items[0].title,
                                                                                      url: items[0].url,
                                                                                      published_at: items[0].publish_date,
                                                                                      channel: channel)

      expect_any_instance_of(EpisodeOperations::SynchronizeAll).to receive(:run).with(EpisodeOperations::Synchronize,
                                                                                      title: items[1].title,
                                                                                      url: items[1].url,
                                                                                      published_at: items[1].publish_date,
                                                                                      channel: channel)

      run(EpisodeOperations::SynchronizeAll, channel: channel, feed_items: items)
    end
  end

  context "when the feed has invalid episodes" do
    before do
      allow_any_instance_of(EpisodeOperations::SynchronizeAll).to receive(:run).with(EpisodeOperations::Synchronize,
                                                                                  title: items[0].title,
                                                                                  url: items[0].url,
                                                                                  published_at: items[0].publish_date,
                                                                                  channel: channel).and_raise("InvalidEpisode")
    end

    it "ignore errors" do
      expect {
        run(EpisodeOperations::SynchronizeAll, channel: channel, feed_items: items)
      }.to_not raise_error("InvalidEpisode")
    end

    it "triggers the next episodes in the sequence" do
      expect_any_instance_of(EpisodeOperations::SynchronizeAll).to receive(:run).with(EpisodeOperations::Synchronize,
                                                                                      title: items[1].title,
                                                                                      url: items[1].url,
                                                                                      published_at: items[1].publish_date,
                                                                                      channel: channel)

      run(EpisodeOperations::SynchronizeAll, channel: channel, feed_items: items)
    end
  end
end
