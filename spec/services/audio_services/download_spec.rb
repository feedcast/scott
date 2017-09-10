require "rails_helper"

RSpec.describe AudioServices::Download do
  context "when the url exists" do
    let(:output_path) { AudioServices::Download.new.call(url) }
    let(:content) { File.read(output_path) }

    let(:valid_file) do
      File.read(Rails.root.join("spec", "fixtures", "valid.mp3"))
    end

    context "and the url is direct" do
      let(:url) { "http://feedcast.com/valid.mp3" }

      it "downloads the given file url" do
        expect(content).to eq(valid_file)
      end
    end

    context "and the url is a redirect" do
      let(:url) { "http://feedcast.com/redirect/valid.mp3" }

      it "downloads the given file url" do
        expect(content).to eq(valid_file)
      end
    end
  end

  context "when the url does not exists" do
    let(:url) { "http://invalid_ur" }

    it "raise an error" do
      expect {
        AudioServices::Download.new.call(url)
      }.to raise_error("invalid address")
    end
  end
end
