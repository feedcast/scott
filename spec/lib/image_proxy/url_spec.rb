require "spec_helper"
require "image_proxy/url"

RSpec.describe ImageProxy::URL do
  let(:url) { ImageProxy::URL.new(original_url, params).to_s }
  let(:original_url) { "https://foo.com/_folder/image_1.png" }
  let(:params) { { } }

  context "when only the original url is given" do
    it "includes the host" do
      expect(url).to match(/https:\/\/images.feedcast.cc/)
    end

    it "encodes the url" do
      expect(url).to match(/https%3A%2F%2Ffoo.com%2F_folder%2Fimage_1.png/)
    end

    it "defaults the height and width to 300x300" do
      expect(url).to match(/\/300\/300/)
    end

    it "assembles in the correct order" do
      expect(url).to eq("https://images.feedcast.cc/https%3A%2F%2Ffoo.com%2F_folder%2Fimage_1.png/300/300")
    end
  end

  context "when we set the height/width" do
    let(:params) { { height: 120, width: 80 } }

    it "uses the given value in the url" do
      expect(url).to match(/\/120\/80/)
    end
  end
end
