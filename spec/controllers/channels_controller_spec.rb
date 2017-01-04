require "rails_helper"

RSpec.describe ChannelsController, type: :controller do
  describe "show" do
    let(:channel) { double(Channel, title: "foo") }
    let(:slug) { "foo" }
    let(:params) do
      { channel: slug }
    end

    context "with valid params" do
      before do
        allow(Channel).to receive(:find).and_return(channel)
      end

      it "returns success" do
        get :show, params: params

        expect(response).to be_success
      end
    end
  end
end
