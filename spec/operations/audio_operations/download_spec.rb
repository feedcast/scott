require "rails_helper"

RSpec.describe AudioOperations::Download, type: :operation do
  context "when the url exists" do
    let!(:output_path) do
      run(AudioOperations::Download, params)
    end

    let(:valid_file) do
      File.read(Rails.root.join("spec", "fixtures", "valid.mp3"))
    end

    context "and the url is direct" do
      let(:params) do
        { url: "http://feedcast.com/valid.mp3" }
      end

      it "downloads the given file url" do
        content = File.read(output_path)

        expect(content).to eq(valid_file)
      end
    end

    context "and the url is a redirect" do
      let(:params) do
        { url: "http://feedcast.com/redirect/valid.mp3" }
      end

      it "downloads the given file url" do
        content = File.read(output_path)

        expect(content).to eq(valid_file)
      end
    end
  end

  context "when the url does not exists" do
    let(:params) do
      { url: "http://invalid_ur" }
    end

    it "raise an error" do
      expect {
        run(AudioOperations::Download, params)
      }.to raise_error("invalid address")
    end
  end
end
