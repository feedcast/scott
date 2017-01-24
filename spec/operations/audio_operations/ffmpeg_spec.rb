require "rails_helper"

RSpec.describe AudioOperations::FFMPEG, type: :operation do
  let(:output) do
    run(AudioOperations::FFMPEG, params)
  end

  context "when the file is valid" do
    let(:params) do
      { file_path:  File.join("spec/fixtures/valid.mp3") }
    end

    it "returns the size" do
      expect(output.size).to be(3428651)
    end

    it "returns the duration" do
      expect(output.duration).to be(362.135378)
    end

    it "returns the codec" do
      expect(output.audio_codec).to eq("mp3")
    end

    it "returns the bitrate" do
      expect(output.audio_bitrate).to be(64000)
    end

    it "returns the sample_rate" do
      expect(output.audio_sample_rate).to be(44100)
    end
  end

  context "when the file is invalid" do
    let(:params) do
      { file_path:  File.join("spec/fixtures/invalid.mp3") }
    end

    it "raises an error" do
      expect {
        run(AudioOperations::FFMPEG, params)
      }.to raise_error(AudioOperations::FFMPEG::InvalidAudioFile, "Invalid Audio File - Invalid argument")
    end
  end
end
