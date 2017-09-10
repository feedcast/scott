require "rails_helper"

RSpec.describe ChannelServices::ScheduleSynchronization do
  let(:channels) do
    [
      Fabricate.build(:channel),
      Fabricate.build(:channel),
      Fabricate.build(:channel)
    ]
  end
  let(:service) { ChannelServices::ScheduleSynchronization.new }

  before do
    allow(Channel).to receive(:all).and_return(channels)
    allow(service).to receive(:schedule_sync_for).and_return(true)
  end

  it "runs synchronize for all the channels" do
    expect(service).to receive(:schedule_sync_for).exactly(3).times

    service.call
  end
end
