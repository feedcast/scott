require "rails_helper"

RSpec.describe ChannelOperations::Synchronize, type: :operation do
  context "when the feed is valid" do
    context "and the feed has only valid episodes" do
      let(:channel) do
        Channel.create(name: "Foo",
                       slug: "foo",
                       feed_url: Rails.root.join("spec/fixtures/02_episodes.xml"))
      end

      context "and it is the first time" do
        it "creates the episodes" do
          expect {
            run(ChannelOperations::Synchronize, channel: channel)
          }.to change{ channel.reload.episodes.size }.from(0).to(2)
        end

        it "sets the channel status to synchronized" do
          run(ChannelOperations::Synchronize, channel: channel)

          expect(channel.reload).to be_synchronized
        end

        describe "new episodes" do
          it "have the correct titles" do
            run(ChannelOperations::Synchronize, channel: channel)

            expect(channel.reload.episodes.map(&:title)).to eq([
              "Episode 001",
              "Episode 002"
            ])
          end

          it "have the correct publication dates" do
            run(ChannelOperations::Synchronize, channel: channel)

            expect(channel.reload.episodes.map(&:published_at)).to eq([
              "Thu, 22 Dec 2016 16:42:42.000000000 +0000",
              "Fri, 23 Dec 2016 15:42:42.000000000 +0000"
            ])
          end
        end
      end

      context "and it is the second time" do
        let(:channel) do
          Channel.create(name: "Foo",
                         slug: "foo",
                         feed_url: Rails.root.join("spec/fixtures/02_episodes.xml"))
        end

        before do
          # Synchronize the first time
          run(ChannelOperations::Synchronize, channel: channel)

          # Update the feed url to simulate new episodes
          channel.feed_url = Rails.root.join("spec/fixtures/05_episodes.xml")
          channel.save!
          channel.reload
        end

        it "creates the new episodes" do
          expect {
            run(ChannelOperations::Synchronize, channel: channel)
          }.to change{ channel.episodes.size }.from(2).to(5)
        end

        it "updates the already existent episodes" do
          expect {
            run(ChannelOperations::Synchronize, channel: channel)
          }.to change{ channel.episodes.first.title }.from("Episode 001").to("Foo - Episode 001")
        end

        describe "new episodes" do
          let(:new_episodes) { channel.episodes.pop(3) }

          it "have the correct titles" do
            run(ChannelOperations::Synchronize, channel: channel)

            expect(new_episodes.map(&:title)).to eq([
              "Episode 003",
              "Episode 004",
              "Episode 005"
            ])
          end

          it "have the correct publication dates" do
            run(ChannelOperations::Synchronize, channel: channel)

            expect(new_episodes.map(&:published_at)).to eq([
              "Sat, 24 Dec 2016 15:42:42.000000000 +0000",
              "Sun, 25 Dec 2016 15:42:42.000000000 +0000",
              "Mon, 26 Dec 2016 15:42:42.000000000 +0000"
            ])
          end
        end
      end
    end

    context "and the feed has invalid episodes" do
      let(:channel) do
        Channel.create(name: "Foo",
                       slug: "foo",
                       feed_url: Rails.root.join("spec/fixtures/02_episodes_01_missing_url.xml"))
      end

      it "creates the valid episodes only" do
        expect {
          run(ChannelOperations::Synchronize, channel: channel)
        }.to change{ channel.episodes.size }.from(0).to(1)
      end

      it "sets the channel status to synchronized" do
        run(ChannelOperations::Synchronize, channel: channel)

        expect(channel).to be_synchronized
      end
    end
  end

  context "when the feed is invalid" do
    let(:channel) do
      Channel.create!(name: "Foo",
                      slug: "foo",
                      feed_url: Rails.root.join("spec/fixtures/invalid.xml"))
    end

    before do
      allow_any_instance_of(ChannelOperations::Synchronize).to receive(:download_feed_for).and_raise(ChannelOperations::DownloadFeed::InvalidFeed.new("invalid feed"))
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
