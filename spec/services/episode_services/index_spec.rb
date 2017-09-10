require "rails_helper"

RSpec.describe EpisodeServices::Index do
  let(:episode) { Fabricate(:episode, title: "Foo & Bar") }
  let(:scully_url) { "search.dev.feedcast.io/index/episode" }
  let(:service) { EpisodeServices::Index.new }
  let(:scully_stub) do
    stub_request(:put, scully_url)
      .with(body: ::EpisodeSearchSerializer.new(episode).to_json)
  end

  before do
    scully_stub
  end

  it "triggers the request properly" do
    service.call(episode)
    assert_requested(:put, scully_url)
  end

  context "when the response is valid" do
    it "updates the indexed_at" do
      expect { service.call(episode) }.to change(episode, :indexed_at)
    end
  end

  context "when the response is invalid" do
    before do
      scully_stub.to_timeout
    end

    it "raises the error" do
      expect { service.call(episode) }.to raise_error(RestClient::RequestTimeout)
    end
  end
end
