require "rails_helper"

RSpec.describe AudioOperations::Analyse, type: :operation do
  let(:audio) { Fabricate(:episode).audio }
  let(:audio_data) do
    double(:audio_data,
           size: 1100,
           duration: 300.0,
           audio_codec: "mp3",
           audio_bitrate: 3000,
           audio_sample_rate: 4400)
  end
  let(:audio_wave) { [ 0, 3, 120, 300, 400 ] }
  let(:tmp_file) { Tempfile.new(audio.id).path.to_s }

  before do
    FileUtils.touch(tmp_file)

    allow_any_instance_of(AudioOperations::Analyse).to receive(:run)
                                                   .with(AudioOperations::Download, url: audio.url)
                                                   .and_return(tmp_file)
    allow_any_instance_of(AudioOperations::Analyse).to receive(:run)
                                                   .with(AudioOperations::FFMPEG, file_path: tmp_file)
                                                   .and_return(audio_data)
    allow_any_instance_of(AudioOperations::Analyse).to receive(:run)
                                                   .with(AudioOperations::Wave, file_path: tmp_file,
                                                                                duration: audio_data.duration)
                                                   .and_return(audio_wave)
  end

  context "when params are valid" do
    it "changes the audio status to analysed" do
      run(AudioOperations::Analyse, audio: audio)

      expect(audio).to be_analysed
    end

    describe "it updates audio" do
      before do
        run(AudioOperations::Analyse, audio: audio)
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

      it "wave" do
        expect(audio.wave).to eq(audio_wave)
      end
    end
  end

  context "when params are invalid" do
    before do
      allow_any_instance_of(AudioOperations::Analyse).to receive(:run)
                                                     .with(AudioOperations::Download, url: audio.url)
                                                     .and_raise("DownloadError")
    end

    it "changes the audio status to failed" do
      run(AudioOperations::Analyse, audio: audio)

      expect(audio).to be_failed
      expect(audio.error_message).to eq("DownloadError")
    end

    it "does not raise the error" do
      expect{
        run(AudioOperations::Analyse, audio: audio)
      }.to_not raise_error
    end
  end
end
