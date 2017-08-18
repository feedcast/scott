require "rails_helper"
require "support/json_response"

RSpec.describe API::V1::Channel, type: :request do
  describe "/channels" do
    let(:channels) { [] }

    before do
      channels

      get "/channels/"
    end

    it "returns success" do
      expect(response).to have_http_status(:success)
    end

    context "when there are no channels" do
      it "returns an empty array" do
        expect(json_response).to eq(channels: [])
      end
    end

    context "when there are channels" do
      let(:channels) do
        [Fabricate(:channel), Fabricate(:channel), Fabricate(:channel)]
      end

      it "returns the array of channels" do
        expect(json_response).to include(:channels)
        expect(json_response[:channels].size).to be(3)
      end

      it "returns with the correct serialization for each channel" do
        serialized_channel = ChannelSerializer.new(Channel.first).as_json

        expect(json_response[:channels]).to include(serialized_channel)
      end
    end
  end

  describe "/channels/:slug" do
    let(:channel) { Fabricate(:channel, categories: []) }
    let(:serialized_channel) { ChannelSerializer.new(channel).as_json }
    let(:slug) { channel.slug }

    before do
      get "/channels/#{slug}"
    end

    context "when the channel exists" do
      it "returns success" do
        expect(response).to have_http_status(:success)
      end

      it "returns the channel information" do
        expect(json_response).to eq(serialized_channel)
      end
    end

    context "when the channel does not exist" do
      let(:slug) { "invalid-slug" }

      it "returns not found" do
        expect(response).to have_http_status(:not_found)
      end

      it "returns the error message" do
        expect(json_response).to eq(message: "not found")
      end
    end
  end

  describe "/channels/:slug/episodes" do
    let(:slug) { channel.slug }

    before do
      get "/channels/#{slug}/episodes"
    end

    context "when the channel does not exist" do
      let(:slug) { "invalid-slug" }

      it "returns not found" do
        expect(response).to have_http_status(:not_found)
      end

      it "returns the error message" do
        expect(json_response).to eq(message: "not found")
      end
    end

    context "when the channel exists" do
      let(:channel) { Fabricate(:channel) }

      it "returns success" do
        expect(response).to have_http_status(:success)
      end

      context "and it does not have any episodes" do
        it "returns an empty array" do
          expect(json_response).to eq(episodes: [])
        end
      end

      context "and it has episodes" do
        let(:channel) { Fabricate(:channel_with_episodes) }
        let(:episodes) { channel.episodes }
        let(:serialized_episode) { EpisodeSerializer.new(episodes.first).as_json }

        it "returns the list of episodes" do
          expect(json_response[:episodes].size).to be(episodes.size)
          expect(json_response[:episodes]).to include(serialized_episode)
        end
      end
    end
  end
end
