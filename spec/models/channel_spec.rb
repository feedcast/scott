require "rails_helper"

RSpec.describe Channel, type: :model do
  it "has a valid factory" do
    channel = Channel.new(name: "foo", slug: "foo")

    expect(channel.save).to eq(true)
  end
end
