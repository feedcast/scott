require "rails_helper"

RSpec.describe "Audio Analysis", type: :operation do
  context "when there are audios to be analysed" do
    let!(:episodes) do
      [
        Fabricate(:episode),
        Fabricate(:episode_with_invalid_audio)
      ]
    end
    let(:valid_audio) { episodes.first.reload.audio }
    let(:invalid_audio) { episodes.last.reload.audio }

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

    context "with the correct audios" do
      it "updates the audio status" do
        expect(invalid_audio).to be_failed
        expect(invalid_audio.duration).to be(0.0)
      end
    end
  end
end
