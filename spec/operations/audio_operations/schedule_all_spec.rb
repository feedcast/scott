require "rails_helper"

RSpec.describe AudioOperations::ScheduleAll, type: :operation do
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
      allow_any_instance_of(AudioOperations::ScheduleAll)
        .to receive(:schedule_analysis_for).with(episode.audio)

      expect_any_instance_of(AudioOperations::ScheduleAll)
        .to receive(:schedule_analysis_for).with(episode.audio)
    end

      expect_any_instance_of(AudioOperations::ScheduleAll)
        .to_not receive(:schedule_analysis_for).with(episodes.last.audio)

    run(AudioOperations::ScheduleAll, {})
  end
end
