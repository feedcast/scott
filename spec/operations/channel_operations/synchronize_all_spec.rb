require "rails_helper"

RSpec.describe ChannelOperations::SynchronizeAll, type: :operation do
  let(:channels) do
    [
      double(Channel, name: "Foo1", slug: "foo1"),
      double(Channel, name: "Foo2", slug: "foo2"),
      double(Channel, name: "Foo3", slug: "foo3")
    ]
  end

  before do
    allow(Channel).to receive(:all).and_return(channels)
    allow_any_instance_of(ChannelOperations::SynchronizeAll).to receive(:synchronize).and_return(true)
  end

  it "runs synchronize for all the channels" do
    expect_any_instance_of(ChannelOperations::SynchronizeAll).to receive(:synchronize).exactly(3).times

    run(ChannelOperations::SynchronizeAll)
  end
end
