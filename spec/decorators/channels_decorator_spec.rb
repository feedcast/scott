require "rails_helper"

RSpec.describe ChannelsDecorator do
  let(:page) { 1 }
  let(:channels) { double(Channel, current_page: page) }
  let(:decorator) { ChannelsDecorator.new(channels) }

  describe "page title" do
    it "shows the expected page title" do
      expect(decorator.page_title).to eq("Channels - Page 1")
    end
  end
end
