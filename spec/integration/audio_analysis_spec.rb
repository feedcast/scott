require "rails_helper"

RSpec.describe "Audio Analysis", type: :operation do
  context "when there are audios to be analysed" do
    let!(:episodes) do
      [
        Fabricate(:episode),
        Fabricate(:episode_with_invalid_audio),
        Fabricate(:episode_with_failed_audio_3_errors)
      ]
    end
    let(:valid_audio) { episodes.first.reload.audio }
    let(:invalid_audio) { episodes.second.reload.audio }
    let(:unanalysable_audio) { episodes.last.reload.audio }

    before do
      run(EpisodeOperations::AnalyseAll, {})
    end

    context "with the correct audios" do
      it "updates the audio info" do
        expect(valid_audio).to be_analysed
        expect(valid_audio.duration).to be(362.135378)
        expect(valid_audio.codec).to eq("mp3")
      end
    end

    context "with the incorrect audios" do
      it "updates the audio status" do
        expect(invalid_audio).to be_failed
        expect(invalid_audio.error_count).to be(1)
        expect(invalid_audio.duration).to be(0.0)
      end
    end

    context "with the unanalysable audios" do
      it "does not update anything" do
        expect(unanalysable_audio).to be_failed
        expect(unanalysable_audio.error_count).to be(3)
        expect(unanalysable_audio.duration).to be(0.0)
      end
    end
  end
end
