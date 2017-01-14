require "rails_helper"

RSpec.describe EpisodeOperations::Synchronize, type: :operation do
  context "when params are valid" do
    let(:channel) { Fabricate(:channel) }

    context "and the episode does not exists" do
      context "and the publish date is in the future" do
        let(:params) do
          {
            title: "Foo 001",
            summary: "shorter",
            description: "foo",
            url: "foo-001.mp3",
            published_at: 14.hours.from_now,
            channel: channel
          }
        end

        it "does not create a new episode" do
          allow_any_instance_of(EpisodeOperations::Synchronize).to receive(:call).and_return(Mongoid::Errors::Validations)
          run(EpisodeOperations::Synchronize, params)

          expect(Episode.count).to eq(0)
        end

        it "raises an error" do
          expect {
            run(EpisodeOperations::Synchronize, params)
          }.to raise_error(Mongoid::Errors::Validations)
        end
      end

      context "and the publish date is in the past" do
        let(:params) do
          {
            title: "Foo 001",
            summary: "shorter",
            description: "foo",
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

        it "populates the episode" do
          run(EpisodeOperations::Synchronize, params)

          episode = Episode.last

          expect(episode.title).to eq(params[:title])
          expect(episode.summary).to eq(params[:summary])
          expect(episode.description).to eq(params[:description])
          expect(episode.audio.url).to eq(params[:url])
          expect(episode.channel_id).to eq(params[:channel].id)
        end
      end
    end

    context "and the episode already exists" do
      let(:episode) do
        Fabricate(:episode, channel: channel)
      end

      let(:params) do
        {
          title: "After Sync",
          summary: "Sum After Sync",
          description: "Desc After Sync",
          url: "after.mp3",
          published_at: episode.published_at.to_time,
          channel: channel
        }
      end

      it "updates the existent episode" do
        run(EpisodeOperations::Synchronize, params)
        episode.reload

        expect(episode.title).to eq(params[:title])
        expect(episode.summary).to eq(params[:summary])
        expect(episode.description).to eq(params[:description])
        expect(episode.audio.url).to eq(params[:url])
        expect(episode.channel_id).to eq(params[:channel].id)
      end
    end
  end
end
