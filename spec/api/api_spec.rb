require "rails_helper"
require "support/json_response"

class API < Grape::API
  namespace :test do
    get :document_not_found do
      raise Mongoid::Errors::DocumentNotFound.new(Channel, foo: "bar")
    end
  end
end

RSpec.describe API, type: :request do
  context "when there is a mongoid document not found error" do
    before do
      get "/api/test/document_not_found"
    end

    it "returns not found" do
      expect(response).to have_http_status(:not_found)
    end

    it "renders the error message" do
      expect(json_response).to eq(message: "not found")
    end
  end
end
