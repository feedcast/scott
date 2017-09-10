require "rails_helper"

RSpec.describe EpisodeServices::IndexOutdated do
  let(:service) { EpisodeServices::IndexOutdated.new }
  let(:episodes) do
    [
      Fabricate.build(:episode, indexed_at: nil, updated_at: 1.hour.ago),
      Fabricate.build(:episode, indexed_at: 1.hour.ago, updated_at: 1.minute.ago),
      Fabricate.build(:episode, indexed_at: 1.minute.ago, updated_at: 1.hour.ago),
    ]
  end

  before do
    allow(Episode).to receive(:all).and_return(episodes)
  end

  it "runs indexer for all outdated the episodes" do
    expect(service).to receive(:schedule_indexer_for).exactly(2).times

    service.call
  end
end
