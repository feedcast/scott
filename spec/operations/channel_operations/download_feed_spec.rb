require "rails_helper"

RSpec.describe ChannelOperations::Synchronize, type: :operation do
  context "when the feed is valid" do
    let(:params) do
      { feed_url: "http://feedcast.com/valid.xml" }
    end

    it "returns the feed object" do
      feed = run(ChannelOperations::DownloadFeed, params)

      expect(feed).to be_an_instance_of(House::Podcast)
      expect(feed.items.size).to eq(2)
    end
  end

  context "when the feed is invalid" do
    let(:params) do
      { feed_url: "http://feedcast.com/invalid.xml" }
    end

    it "raises an error" do
      expect {
        run(ChannelOperations::DownloadFeed, params)
      }.to raise_error(ChannelOperations::DownloadFeed::InvalidFeed)
    end
  end
end
