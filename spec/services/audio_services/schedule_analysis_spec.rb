require "rails_helper"

RSpec.describe AudioServices::ScheduleAnalysis do
  let!(:episodes) do
    [
      Fabricate(:episode),
      Fabricate(:episode),
      Fabricate(:episode),
      Fabricate(:episode_with_failed_audio),
      Fabricate(:episode_with_analysed_audio),
    ]
  end
  let(:service) { AudioServices::ScheduleAnalysis.new }

  it "runs only the not analysed ones" do
    episodes.first(4).each do |episode|
      allow(service).to receive(:schedule_analysis_for).with(episode.audio)

      expect(service).to receive(:schedule_analysis_for).with(episode.audio)
    end

    expect(service).to_not receive(:schedule_analysis_for).with(episodes.last.audio)

    service.call
  end
end
