require "rails_helper"
require "support/json_response"

RSpec.describe API::V1::Episode, type: :request do
  describe "/episodes" do
    let!(:episodes) { [] }

    before do
      get "/episodes"
    end

    it "returns success" do
      expect(response).to have_http_status(:success)
    end

    context "when there are no episodes" do
      it "returns an empty array" do
        expect(json_response).to eq(episodes: [])
      end
    end

    context "when there are episodes" do
      let(:episodes) do
        [Fabricate(:episode), Fabricate(:episode), Fabricate(:episode)]
      end

      it "returns the array of episodes" do
        expect(json_response).to include(:episodes)
        expect(json_response[:episodes].size).to be(3)
      end

      it "returns with the correct serialization for each episode" do
        serialized_episode = EpisodeSerializer.new(Episode.first).as_json

        expect(json_response[:episodes]).to include(serialized_episode)
      end
    end
  end

  describe "/episodes/:channel_slug/:episode_slug" do
    let(:episode) { Fabricate(:episode) }
    let(:serialized_episode) { EpisodeSerializer.new(episode).as_json }
    let(:channel_slug) { episode.channel.slug }
    let(:episode_slug) { episode.slug }

    before do
      get "/episodes/#{channel_slug}/#{episode_slug}"
    end

    context "when the channel exists" do
      context "when the episode exists" do
        it "returns success" do
          expect(response).to have_http_status(:success)
        end

        it "returns the episode information" do
          expect(json_response).to eq(serialized_episode)
        end
      end

      context "when the episode does not exist" do
        let(:episode_slug) { "invalid-episode" }

        it "returns not found" do
          expect(response).to have_http_status(:not_found)
        end

        it "returns the error message" do
          expect(json_response).to eq(message: "not found")
        end
      end
    end

    context "when the channel does not exist" do
      let(:channel_slug) { "invalid-channel" }

      it "returns not found" do
        expect(response).to have_http_status(:not_found)
      end

      it "returns the error message" do
        expect(json_response).to eq(message: "not found")
      end
    end
  end

  describe "/episodes/:channel_slug/:episode_slug/next" do
    let(:episode) { Fabricate(:episode) }
    let(:amount) { 1 }
    let(:channel_slug) { episode.channel.slug }
    let(:episode_slug) { episode.slug }

    before do
      allow_any_instance_of(EpisodeServices::Next).to receive(:call).and_return([episode, episode])

      get "/episodes/#{channel_slug}/#{episode_slug}/next/#{amount}"
    end

    context "when the episode exists" do
      context "when the amount is bigger than 0 and smaller than 10" do
        let(:amount) { 5 }

        it "returns success" do
          expect(response).to have_http_status(:success)
        end

        it "returns the expected content" do
          serialized_episode = EpisodeSerializer.new(episode).as_json

          expect(json_response[:episodes]).to include(serialized_episode)
        end
      end

      context "when the amount is bigger than 10" do
        let(:amount) { 100 }

        it "returns bad request" do
          expect(response).to have_http_status(:bad_request)
        end

        it "returns the error message" do
          expect(json_response).to eq(error: "amount does not have a valid value")
        end
      end

      context "when the amount is lower or equal to 0" do
        let(:amount) { 0 }

        it "returns bad request" do
          expect(response).to have_http_status(:bad_request)
        end

        it "returns the error message" do
          expect(json_response).to eq(error: "amount does not have a valid value")
        end
      end
    end

    context "when the episode does not exist" do
      let(:episode_slug) { "invalid-slug" }

      it "returns not found" do
        expect(response).to have_http_status(:not_found)
      end

      it "returns the error message" do
        expect(json_response).to eq(message: "not found")
      end
    end
  end
end
