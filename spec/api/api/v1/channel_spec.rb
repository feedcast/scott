require "rails_helper"
require "support/json_response"

RSpec.describe API::V1::Channel, type: :request do
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
