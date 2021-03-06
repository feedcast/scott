require "rails_helper"

RSpec.describe AudioServices::Analyse do
  let(:audio) { Fabricate(:episode).audio }
  let(:audio_data) do
    double(:audio_data,
           size: 1100,
           duration: 300.0,
           audio_codec: "mp3",
           audio_bitrate: 3000,
           audio_sample_rate: 4400)
  end
  let(:service) { AudioServices::Analyse.new }
  let(:tmp_file) { Tempfile.new(audio.id).path.to_s }

  before do
    FileUtils.touch(tmp_file)

    allow(service).to receive(:download).with(audio.url).and_return(tmp_file)
    allow(service).to receive(:ffmpeg).with(tmp_file).and_return(audio_data)
  end

  context "when params are valid" do
    it "changes the audio status to analysed" do
      service.call(audio)

      expect(audio).to be_analysed
    end

    describe "it updates audio" do
      before do
        service.call(audio)
      end

      it "size" do
        expect(audio.size).to be(1100)
      end

      it "duration" do
        expect(audio.duration).to be(300.0)
      end

      it "codec" do
        expect(audio.codec).to eq("mp3")
      end

      it "birate" do
        expect(audio.bitrate).to be(3000)
      end

      it "sample_rate" do
        expect(audio.sample_rate).to be(4400)
      end
    end
  end

  context "when params are invalid" do
    before do
      allow(service).to receive(:download).with(audio.url).and_raise("DownloadError")
    end

    it "changes the audio status to failed" do
      service.call(audio)

      expect(audio).to be_failed
      expect(audio.error_message).to eq("DownloadError")
    end

    it "does not raise the error" do
      expect{
        service.call(audio)
      }.to_not raise_error
    end
  end
end
