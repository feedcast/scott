require "rails_helper"

RSpec.describe EpisodeOperations::AnalyseAll, type: :operation do
  let!(:episodes) do
    [
      Fabricate(:episode),
      Fabricate(:episode),
      Fabricate(:episode),
      Fabricate(:episode_with_failed_audio),
      Fabricate(:episode_with_analysed_audio),
    ]
  end

  it "runs only the not analysed ones" do
    episodes.first(4).each do |episode|
      allow_any_instance_of(EpisodeOperations::AnalyseAll)
        .to receive(:run)
        .with(AudioOperations::Analyse, audio: episode.audio)

      expect_any_instance_of(EpisodeOperations::AnalyseAll)
        .to receive(:run)
        .with(AudioOperations::Analyse, audio: episode.audio)
    end

    expect_any_instance_of(EpisodeOperations::AnalyseAll)
      .to_not receive(:run)
      .with(AudioOperations::Analyse, audio: episodes.last.audio)

    run(EpisodeOperations::AnalyseAll, {})
  end
end
