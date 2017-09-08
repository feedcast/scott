require "rails_helper"

RSpec.describe EpisodeOperations::IndexAllOutdated, type: :operation do
  let(:episodes) do
    [
      Fabricate.build(:episode, indexed_at: nil, updated_at: 1.hour.ago),
      Fabricate.build(:episode, indexed_at: 1.hour.ago, updated_at: 1.minute.ago),
      Fabricate.build(:episode, indexed_at: 1.minute.ago, updated_at: 1.hour.ago)
    ]
  end

  before do
    allow(Episode).to receive(:all).and_return(episodes)
  end

  it "runs indexer for all outdated the episodes" do
    expect_any_instance_of(EpisodeOperations::IndexAllOutdated).to receive(:schedule_indexer_for).exactly(2).times

    run(EpisodeOperations::IndexAllOutdated)
  end
end
