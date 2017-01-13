require "rails_helper"

RSpec.describe "Synchronizer", type: :operation do
  before do
    run(ChannelOperations::Synchronize, channel: channel)
  end

  context "when the feed is valid" do
    context "and the channel has never synchronized before" do
      context "and the feed has episodes" do
        context "and all the episodes are valid" do
          let(:channel) { Fabricate(:channel_with_a_valid_feed) }

          it "changes the status to synchronized" do
            expect(channel).to be_synchronized
          end

          it "creates the episodes in the database" do
            expect(channel.episodes.count).to eq(2)
          end
        end

        context "and there are invalid episodes" do
          let(:channel) { Fabricate(:channel_with_a_valid_feed_and_some_invalid_episodes) }

          it "changes the status to synchronized" do
            expect(channel).to be_synchronized
          end

          it "creates only the valid episodes in the database" do
            expect(channel.episodes.count).to eq(1)
          end
        end
      end

      context "and the feed is empty" do
        let(:channel) { Fabricate(:channel_with_an_empty_feed) }

        it "changes the status to synchronized" do
          expect(channel).to be_synchronized
        end

        it "does not create any episodes in the database" do
          expect(channel.episodes.count).to eq(0)
        end
      end
    end

    context "and the channel already synchronized before" do
      let(:channel) { Fabricate(:channel_with_a_valid_feed) }

      before do
        channel.feed_url = "http://feedcast.com/valid_with_5_episodes.xml"
      end

      it "updates the channel episodes count" do
        expect {
          run(ChannelOperations::Synchronize, channel: channel)
        }.to change { channel.episodes.count }.from(2).to(5)
      end
    end
  end

  context "when the feed is invalid" do
    context "because the XML has errors" do
      let(:channel) { Fabricate(:channel_with_an_invalid_feed) }

      it "changes the status to failed" do
        expect(channel).to be_failed
      end

      it "sets the status message" do
        expect(channel.synchronization_status_message).to include("The supplied url is not a valid podcast rss")
      end
    end

    context "because the request fails" do
      let(:channel) { Fabricate(:channel_with_an_invalid_feed_url) }

      it "changes the status to failed" do
        expect(channel).to be_failed
      end

      it "sets the status message" do
        expect(channel.synchronization_status_message).to include("The supplied url is not a valid podcast rss")
      end
    end
  end
end
