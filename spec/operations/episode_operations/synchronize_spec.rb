require "rails_helper"

RSpec.describe EpisodeOperations::Synchronize, type: :operation do
  context "when params are valid" do
    let(:channel) { Channel.create(name: "Foo", slug: "foo") }

    context "and the episode does not exists" do
      let(:params) do
        {
          title: "Foo 001",
          url: "foo-001.mp3",
          published_at: Time.parse("01-01-2017 19:30"),
          channel: channel
        }
      end

      it "creates a new episode" do
        expect {
          run(EpisodeOperations::Synchronize, params)
        }.to change(Episode, :count).by(1)
      end
    end

    context "and the episode already exists" do
      let(:published_at) { Time.now }
      let!(:episode) do
        Episode.create(title: "Before Sync",
                       url: "before.mp3",
                       published_at: published_at,
                       channel_id: channel.id)
      end
      let(:params) do
        {
          title: "After Sync",
          url: "after.mp3",
          published_at: published_at,
          channel: channel
        }
      end

      it "updates the existent episode" do
        run(EpisodeOperations::Synchronize, params)
        episode.reload

        expect(episode.title).to eq(params[:title])
        expect(episode.url).to eq(params[:url])
      end
    end
  end
end