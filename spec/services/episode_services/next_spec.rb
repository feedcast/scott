require "rails_helper"

RSpec.describe EpisodeServices::Next do
  let!(:channel) { Fabricate(:channel, title: "Foo") }
  let!(:other_channel) { Fabricate(:channel_with_episodes) }
  let(:episode) { episodes.third }
  let(:episodes) do
    [
      Fabricate(:episode, title: "Episode 005", published_at: 1.days.ago, channel: channel),
      Fabricate(:episode, title: "Episode 004", published_at: 2.days.ago, channel: channel),
      Fabricate(:episode, title: "Episode 003", published_at: 3.days.ago, channel: channel),
      Fabricate(:episode, title: "Episode 002", published_at: 4.days.ago, channel: channel),
      Fabricate(:episode, title: "Episode 001", published_at: 5.days.ago, channel: channel),
    ]
  end
  let(:amount) { 1 }
  let(:service) { EpisodeServices::Next.new.call(episode, amount) }
  let(:next_episodes) { service }

  context "when there are other episodes for the channel" do
    context "and there are recentest episode" do
      context "and the given amount is 1" do
        it "returns the next published episode" do
          expect(next_episodes).to eq([episodes.second])
        end
      end

      context "and the given amount is 2" do
        let(:amount) { 2 }

        it "returns the next 2 published episodes" do
          expect(next_episodes).to eq([episodes.second, episodes.first])
        end
      end

      context "when there are no other episodes for the same channel" do
        let(:amount) { 10 }

        it "returns a random episode from other channel" do
          expect(next_episodes.map(&:channel)).to include(other_channel)
        end

        it "does not returns the same episode" do
          expect(next_episodes.map(&:id)).to_not eq(episode.id)
        end
      end
    end
  end

  context "when there are no other episodes at all" do
    let(:other_channel) { nil }
    let(:episodes) { [] }
    let(:episode) { Fabricate(:episode, channel: channel) }

    it "returns an empty array" do
      expect(next_episodes).to be_empty
    end
  end
end
