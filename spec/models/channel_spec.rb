require "rails_helper"

RSpec.describe Channel, type: :model do
  describe "synchronization" do
    let(:channel) { Fabricate(:channel) }

    it "default value is new" do
      expect(channel.synchronization_status).to eq(:new)
    end

    describe "synchronization success!" do
      before do
        channel.synchronization_success!
      end

      it "sets the feed_synchronization_status to success" do
        expect(channel).to be_synchronized
      end

      it "sets synchronization date to now" do
        expect(channel.synchronized_at).to be_between(1.second.ago, Time.now)
      end

      it "cleans the failure message" do
        expect(channel.synchronization_status_message).to be_empty
      end
    end

    describe "synchronization failure!" do
      before do
        channel.synchronization_failure!("Feed is Invalid")
      end

      it "sets the feed_synchronization_status to success" do
        expect(channel).to be_failed
      end

      it "sets synchronization date to now" do
        expect(channel.synchronized_at).to be_between(1.second.ago, Time.now)
      end

      it "stores the reason for the failure" do
        expect(channel.synchronization_status_message).to eq("Feed is Invalid")
      end
    end
  end

  describe "search" do
    let!(:channels) do
      [
        Fabricate(:channel, title: "Nerd"),
        Fabricate(:channel, title: "Nerdcast"),
        Fabricate(:channel, title: "Paranerdia"),
        Fabricate(:channel, title: "This is nerd"),
        Fabricate(:channel, title: "NeRD"),
        Fabricate(:channel, title: "My Podcast"),
        Fabricate(:channel, title: "Alone"),
        Fabricate(:channel, title: "Foo"),
        Fabricate(:channel, title: "Bar"),
      ]
    end

    context "when there are results" do
      it "finds exact matches" do
        expect(Channel.search("Bar").map(&:title)).to include("Bar")
      end

      it "finds titles that start with" do
        expect(Channel.search("Nerd").map(&:title)).to include("Nerdcast")
      end

      it "finds titles that include the word" do
        expect(Channel.search("cast").map(&:title)).to eq(["Nerdcast", "My Podcast"])
      end

      it "finds title regardless of the case" do
        expect(Channel.search("NeRd").map(&:title)).to eq(["Nerd", "Nerdcast", "Paranerdia", "This is nerd", "NeRD"])
      end
    end

    context "when there are not results" do
      it "returns an empty criteria" do
        expect(Channel.search("Invalid").count).to eq(0)
      end
    end
  end

  describe "listed" do
    let!(:channels) do
      [
        Fabricate(:channel, listed: true),
        Fabricate(:channel, listed: true),
        Fabricate(:channel, listed: false),
        Fabricate(:channel, listed: false),
      ]
    end

    it "returns only the listed channels" do
      expect(Channel.listed.count).to eq(2)
      expect(Channel.listed).to eq(channels.first(2))
    end
  end
end
