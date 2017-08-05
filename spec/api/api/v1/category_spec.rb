require "rails_helper"
require "support/json_response"

RSpec.describe API::V1::Category, type: :request do
  describe "/categories" do
    let(:categories) { [] }

    before do
      categories

      get "/categories/"
    end

    it "returns success" do
      expect(response).to have_http_status(:success)
    end

    context "when there are no categories" do
      it "returns an empty array" do
        expect(json_response).to eq(categories: [])
      end
    end

    context "when there are categories" do
      let(:categories) do
        [Fabricate(:category), Fabricate(:category), Fabricate(:category)]
      end

      it "returns the array of categories" do
        expect(json_response).to include(:categories)
        expect(json_response[:categories].size).to be(3)
      end

      it "returns with the correct serialization for each category" do
        serialized_category = ::CategorySerializer.new(categories.first).as_json

        expect(json_response[:categories]).to include(serialized_category)
      end
    end
  end

  describe "/categories/:slug" do
    let(:category) { Fabricate(:category_with_channels) }
    let(:serialized_category) { ::CategorySerializer.new(category).as_json }
    let(:slug) { category.slug }

    before do
      get "/categories/#{slug}"
    end

    context "when the category exists" do
      it "returns success" do
        expect(response).to have_http_status(:success)
      end

      it "returns the category information" do
        expect(json_response).to eq(serialized_category)
      end
    end

    context "when the category does not exist" do
      let(:slug) { "invalid-slug" }

      it "returns not found" do
        expect(response).to have_http_status(:not_found)
      end

      it "returns the error message" do
        expect(json_response).to eq(message: "not found")
      end
    end
  end
end
