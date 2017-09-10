require "rails_helper"

RSpec.describe ChannelServices::DownloadFeed do
  context "when the feed is valid" do
    let(:feed_url) { "http://feedcast.com/valid.xml" }

    it "returns the feed object" do
      feed = ChannelServices::DownloadFeed.new.call(feed_url)

      expect(feed).to be_an_instance_of(House::Podcast)
      expect(feed.items.size).to eq(2)
    end
  end

  context "when the feed is invalid" do
    let(:feed_url) { "http://feedcast.com/invalid.xml" }

    it "raises an error" do
      expect {
        ChannelServices::DownloadFeed.new.call(feed_url)
      }.to raise_error(ChannelServices::DownloadFeed::InvalidFeed)
    end
  end
end
