require "rails_helper"

RSpec.describe AudioServices::ScheduleAnalysis do
  let(:episodes) do
    [
      double(:episode, audio: double(:audio)),
      double(:episode, audio: double(:audio)),
      double(:episode, audio: double(:audio)),
    ]
  end
  let(:service) { AudioServices::ScheduleAnalysis.new }

  before do
    allow(Episode).to receive(:not_analysed).and_return(episodes)
  end

  it "schedule an analysis for the return of the query" do
    episodes.each do |episode|
      allow(service).to receive(:schedule_analysis_for).with(episode.audio)

      expect(service).to receive(:schedule_analysis_for).with(episode.audio)
    end

    service.call
  end
end
