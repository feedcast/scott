require "rails_helper"

RSpec.describe Episode, type: :model do
  let(:channel) { Fabricate(:channel) }

  describe "scopes" do
    describe "find for channel" do
      let(:other_channel) { Fabricate(:channel) }
      let(:episode) { episodes.third }
      let(:episodes) do
        [
          Fabricate(:episode, title: "foo", channel: other_channel),
          Fabricate(:episode, title: "bar", channel: channel),
          Fabricate(:episode, title: "foo", channel: channel)
        ]
      end

      context "when the channel and episode slugs are valid" do
        it "returns the expected episode" do
          expect(Episode.find_for(channel.slug, episode.slug)).to eq(episode)
        end
      end

      context "when the channel slug is not valid" do
        it "raises error" do
          expect {
            Episode.find_for("invalid", episode.slug)
          }.to raise_error(Mongoid::Errors::DocumentNotFound)
        end
      end

      context "when the episode slug is not valid" do
        it "raises error" do
          expect {
            Episode.find_for(channel.slug, "invalid")
          }.to raise_error(Mongoid::Errors::DocumentNotFound)
        end
      end
    end

    describe "not analised" do
      let!(:episodes) do
        [
          Fabricate(:episode),
          Fabricate(:episode_with_failed_audio),
          Fabricate(:episode_with_failed_audio_2_errors),
          Fabricate(:episode_with_failed_audio_3_errors),
          Fabricate(:episode_with_analysed_audio)
        ]
      end

      it "returns only the episodes with new/failed status with less than 3 attemps" do
        expect(Episode.not_analysed).to eq(episodes.first(3))
      end
    end
  end
end
