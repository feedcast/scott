require "rails_helper"

RSpec.describe EpisodesController, type: :controller do
  describe "show" do
    let(:channel) { Fabricate.build(:channel_with_episodes) }
    let(:episodes) { channel.episodes }
    let(:episode) { episodes.first }
    let(:params) do
      {
        channel: channel.slug,
        episode: episode.slug
      }
    end

    context "with valid params" do
      before do
        allow(Channel).to receive(:find).and_return(channel)
        allow(episodes).to receive(:find).and_return(episode)
      end

      it "returns success" do
        get :show, params: params

        expect(response).to be_success
      end
    end
  end
end
