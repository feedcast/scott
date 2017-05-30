require "rails_helper"
require "support/json_response"

RSpec.describe API::V1::Episode, type: :request do
  describe "/api/episodes" do
    let(:episodes) { [] }

    before do
      episodes

      get "/api/episodes/"
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

  describe "/api/episodes/:uuid" do
    let(:episode) { Fabricate(:episode) }
    let(:serialized_episode) { EpisodeSerializer.new(episode).as_json }
    let(:uuid) { episode.uuid }

    before do
      get "/api/episodes/#{uuid}"
    end

    context "when the episode exists" do
      it "returns success" do
        expect(response).to have_http_status(:success)
      end

      it "returns the episode information" do
        expect(json_response).to eq(serialized_episode)
      end
    end

    context "when the episode does not exist" do
      let(:uuid) { "invalid-uuid" }

      it "returns not found" do
        expect(response).to have_http_status(:not_found)
      end

      it "returns the error message" do
        expect(json_response).to eq(message: "not found")
      end
    end
  end
end
