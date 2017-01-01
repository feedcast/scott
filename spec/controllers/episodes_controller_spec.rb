require "rails_helper"

RSpec.describe EpisodesController, type: :controller do
  describe "show" do
    let(:channel) { double(Channel, name: "foo", slug: "foo", episodes: episodes) }
    let(:episodes) { double(:episodes) }
    let(:episode) { double(Episode, uuid: "a32", title: "foo") }
    let(:params) do
      {
        channel: channel.slug,
        episode: episode.uuid
      }
    end

    context "with valid params" do
      before do
        allow(Channel).to receive(:find_by).and_return(channel)
        allow(episodes).to receive(:find_by).and_return(episode)
      end

      it "returns success" do
        get :show, params: params

        expect(response).to be_success
      end
    end
  end
end
