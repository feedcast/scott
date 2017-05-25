require "rails_helper"
require "support/json_response"

RSpec.describe API::V1::Channel, type: :request do
  describe "/api/channels" do
    let(:channels) { [] }

    before do
      channels

      get "/api/channels/"
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
        channel = ChannelSerializer.new(Channel.first).as_json

        expect(json_response[:channels].first).to eq(channel)
      end
    end
  end

  describe "/api/channels/:uuid" do
    let(:channel) { Fabricate(:channel) }
    let(:uuid) { channel.uuid }

    before do
      get "/api/channels/#{uuid}"
    end

    context "when the uuid is valid" do
      it "returns success" do
        expect(response).to have_http_status(:success)
      end

      it "returns the channel information" do
        expect(json_response).to eq(
          uuid: channel.uuid,
          slug: channel.slug,
          title: channel.title,
          description: channel.description
        )
      end
    end

    context "when the uuid is not valid" do
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
