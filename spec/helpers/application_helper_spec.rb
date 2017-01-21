require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "application title" do
    context "when there is no content" do
      it "returns the default title" do
        expect(helper.application_title).to eq("Feedcast")
      end
    end

    context "when there is content" do
      it "returns the compound title" do
        helper.content_for(:title, "foo")

        expect(helper.application_title).to eq("foo | Feedcast")
      end
    end
  end
  describe "image url for cannel" do
    context "when the channel image is present" do
      let(:channel) { Fabricate.build(:channel, image_url: "foo.png") }

      it "returns the url" do
        expect(helper.image_url_for(channel)).to eq("foo.png")
      end
    end

    context "when the channel image is not valid" do
      it "returns the placeholder for nil" do
        channel = Fabricate.build(:channel, title: "foooo", image_url: nil)

        expect(helper.image_url_for(channel)).to eq("http://placehold.it/350x150?text=foooo")
      end
    end

    it "returns the placeholder for empty" do
      channel = Fabricate.build(:channel, title: "foooo", image_url: "")

      expect(helper.image_url_for(channel)).to eq("http://placehold.it/350x150?text=foooo")
    end


    it "truncates big titles" do
      channel = Fabricate.build(:channel, title: "This-is-a-really-big-title", image_url: "")

      expect(helper.image_url_for(channel)).to eq("http://placehold.it/350x150?text=This-is-a-re...")
    end

    it "url-encodes titles" do
      channel = Fabricate.build(:channel, title: "This is a not url safe title", image_url: "")

      expect(helper.image_url_for(channel)).to eq("http://placehold.it/350x150?text=This%20is%20a%20no...")
    end
  end

  describe "format duration" do
    it "converts seconds to the specified format" do
      expect(helper.format_duration(60)).to eq("00:01:00")
    end
  end
end
