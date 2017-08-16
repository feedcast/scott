require "rails_helper"

RSpec.describe ChannelOperations::IndexAllOutdated, type: :operation do
  let(:channels) do
    [
      Fabricate.build(:channel, indexed_at: nil, updated_at: 1.hour.ago),
      Fabricate.build(:channel, indexed_at: 1.hour.ago, updated_at: 1.minute.ago),
      Fabricate.build(:channel, indexed_at: 1.minute.ago, updated_at: 1.hour.ago)
    ]
  end

  before do
    allow(Channel).to receive(:all).and_return(channels)
  end

  it "runs indexer for all outdated the channels" do
    expect_any_instance_of(ChannelOperations::IndexAllOutdated).to receive(:schedule_indexer_for).exactly(2).times

    run(ChannelOperations::IndexAllOutdated)
  end
end
