require "rails_helper"

RSpec.describe EpisodeOperations::Index, type: :operation do
  let(:episode) { Fabricate(:episode, title: "Foo & Bar") }
  let(:scully_url) { "search.dev.feedcast.io/index/episode" }
  let(:index) { run(EpisodeOperations::Index, episode: episode) }
  let(:scully_stub) do
    stub_request(:put, scully_url)
      .with(body: { uuid: episode.uuid, title: episode.title }.to_json)
  end

  before do
    scully_stub
  end

  it "triggers the request properly" do
    index
    assert_requested(:put, scully_url)
  end

  context "when the response is valid" do
    it "updates the indexed_at" do
      expect { index }.to change(episode, :indexed_at)
    end
  end

  context "when the response is invalid" do
    before do
      scully_stub.to_timeout
    end

    it "raises the error" do
      expect { index }.to raise_error(RestClient::RequestTimeout)
    end

    it "does not update the indexed_at" do
      expect { index }.to raise_error(RestClient::RequestTimeout)
    end
  end
end
