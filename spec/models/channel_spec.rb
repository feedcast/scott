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
end
