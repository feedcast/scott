require "rails_helper"

class Foo
  include Mongoid::Document
end

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      raise Mongoid::Errors::DocumentNotFound.new(Foo, [])
    end
  end

  context "when a document not found error is raised" do
    it "returns with not found status" do
      get :index

      expect(response).to have_http_status(:not_found)
    end
  end
end
