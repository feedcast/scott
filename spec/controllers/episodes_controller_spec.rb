require "rails_helper"

RSpec.describe EpisodesController, type: :controller do
  describe "show" do
    let(:channel) { Fabricate.build(:channel_with_episodes) }
    let(:episode) { channel.episodes.first }
    let(:params) do
      {
        channel: channel.slug,
        episode: episode.slug
      }
    end

    context "with valid params" do
      let(:user_id) { SecureRandom.uuid }

      before do
        allow(Episode).to receive(:find_for).with(channel.slug, episode.slug).and_return(episode)
        allow(EpisodeListen).to receive(:create).with(anything).and_return(true)
        allow_any_instance_of(EpisodesController).to receive(:user_id).and_return(user_id)
      end

      it "returns success" do
        get :show, params: params

        expect(response).to be_success
      end

      it "stores the episode listens with the correct values" do
        expect(EpisodeListen).to receive(:create).with(user_id: user_id , episode: episode)

        get :show, params: params
      end
    end
  end
end
