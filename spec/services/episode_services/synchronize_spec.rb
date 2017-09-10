require "rails_helper"

RSpec.describe EpisodeServices::Synchronize do
  let(:service) { EpisodeServices::Synchronize.new }

  context "when params are valid" do
    let(:channel) { Fabricate(:channel) }

    context "and the episode does not exists" do
      context "and the publish date is in the future" do
        let(:run) do
          service.call("Foo 001", "shorter", "foo", "foo-001.mp3", 14.hours.from_now, channel)
        end

        before do
          allow(service).to receive(:call).and_raise("Error")
        end

        it "does not create a new episode" do
          expect { run }.to raise_error("Error")

          expect(Episode.count).to eq(0)
        end

        it "raises an error" do
          expect { run }.to raise_error("Error")
        end
      end

      context "and the publish date is in the past" do
        let(:run) do
          service.call("Foo 001", "shorter", "foo", "foo-001.mp3", Time.parse("01-01-2017 19:30"), channel)
        end

        it "creates a new episode" do
          expect { run }.to change(Episode, :count).by(1)
        end

        it "populates the episode" do
          run

          episode = Episode.last

          expect(episode.title).to eq("Foo 001")
          expect(episode.summary).to eq("shorter")
          expect(episode.description).to eq("foo")
          expect(episode.audio.url).to eq("foo-001.mp3")
          expect(episode.channel_id).to eq(channel.id)
        end
      end
    end

    context "and the episode already exists" do
      let(:episode) do
        Fabricate(:episode, channel: channel)
      end

      let(:run) do
        service.call("After Sync", "Sum After Sync", "Desc After Sync", "after.mp3", episode.published_at.to_time, channel)
      end

      it "updates the existent episode" do
        run
        episode.reload

        expect(episode.title).to eq("After Sync")
        expect(episode.summary).to eq("Sum After Sync")
        expect(episode.description).to eq("Desc After Sync")
        expect(episode.audio.url).to eq("after.mp3")
        expect(episode.channel_id).to eq(channel.id)
      end
    end
  end
end
