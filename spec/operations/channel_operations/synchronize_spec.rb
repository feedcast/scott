require "rails_helper"

RSpec.describe ChannelOperations::Synchronize, type: :operation do
  context "when the feed is valid" do
    context "and the feed has episodes" do
      let(:channel) do
        Channel.create(name: "Foo",
                       slug: "foo",
                       feed_url: Rails.root.join("spec/fixtures/02_episodes.xml"))
      end

      context "and it is the first time" do
        it "creates the episodes" do
          expect {
            run(ChannelOperations::Synchronize, channel: channel)
          }.to change{ channel.episodes.size }.from(0).to(2)
        end

        describe "new episodes" do
          it "have the correct titles" do
            run(ChannelOperations::Synchronize, channel: channel)

            expect(channel.episodes.map(&:title)).to eq([
              "Episode 001",
              "Episode 002"
            ])
          end

          it "have the correct publication dates" do
            run(ChannelOperations::Synchronize, channel: channel)

            expect(channel.episodes.map(&:published_at)).to eq([
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
  end

  context "when the feed is invalid" do
    let(:channel) do
      Channel.create(name: "Foo",
                     slug: "foo",
                     feed_url: Rails.root.join("spec/fixtures/invalid.xml"))
    end

    it "raises an error" do
      expect {
        run(ChannelOperations::Synchronize, channel: channel)
      }.to raise_error(ChannelOperations::DownloadFeed::InvalidFeed)
    end
  end
end
