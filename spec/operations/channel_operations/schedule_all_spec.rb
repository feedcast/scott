require "rails_helper"

RSpec.describe ChannelOperations::ScheduleAll, type: :operation do
  let(:channels) do
    [
      Fabricate.build(:channel),
      Fabricate.build(:channel),
      Fabricate.build(:channel)
    ]
  end

  before do
    allow(Channel).to receive(:all).and_return(channels)
    allow_any_instance_of(ChannelOperations::ScheduleAll).to receive(:schedule_sync_for).and_return(true)
  end

  it "runs synchronize for all the channels" do
    expect_any_instance_of(ChannelOperations::ScheduleAll).to receive(:schedule_sync_for).exactly(3).times

    run(ChannelOperations::ScheduleAll)
  end
end
