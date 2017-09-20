require "rails_helper"

RSpec.describe EpisodeServices::CleanIndex do
  let(:service) { EpisodeServices::CleanIndex.new.call }
  let!(:episodes) do
  [
    Fabricate(:episode, indexed_at: 1.minute.ago),
    Fabricate(:episode, indexed_at: 1.day.ago)
  ]
  end

  it "runs indexer for all outdated the episodes" do
    service

    expect(Episode.all.map { |i| i.indexed_at }).to all(be_nil)
  end
end
