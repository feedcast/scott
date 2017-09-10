require "rails_helper"

RSpec.describe EpisodeServices::SynchronizeAll do
  let(:service) { EpisodeServices::SynchronizeAll.new }
  let(:episodes) do
    [
      Fabricate.build(:episode, published_at: Time.parse("01-01-2016 01:10:10")),
      Fabricate.build(:episode, published_at: Time.parse("01-01-2016 02:10:10")),
    ]
  end
  let(:channel) { Fabricate.build(:channel, episodes: episodes) }

  context "when the feed has no items at all" do
    let(:items) do
      []
    end

    it "does not trigger any episode synchronization" do
      expect(service).to_not receive(:synchronize)

      service.call(items, channel)
    end
  end

  context "when the feed has items" do
    let(:items) do
      [
        double(:item, title: "foo-1", summary: "shorter-1", description: "001", url: "bar-1.mp3", publish_date: Time.parse("01-01-2017 10:10:10")),
        double(:item, title: "foo-2", summary: "shorter-2", description: "002", url: "bar-2.mp3", publish_date: Time.parse("01-01-2017 11:10:10")),
      ]
    end

    context "and there is no new item to be published" do
      before do
        allow(service).to receive(:synchronize)
      end

      let(:episodes) do
        [
          Fabricate.build(:episode, published_at: Time.parse("01-02-2017 10:10:10")),
          Fabricate.build(:episode, published_at: Time.parse("01-02-2017 11:10:10")),
        ]
      end

      it "does not trigger any episode synchronization" do
        expect(service).to_not receive(:synchronize)

        service.call(items, channel)
      end
    end

    context "with only valid episodes" do
      it "triggers each episode synchronization" do
        expect(service).to receive(:synchronize).exactly(2).times

        service.call(items, channel)
      end
    end

    context "with invalid episodes" do
      let(:items) do
        [
          double(:item, title: "foo-1", summary: "shorter-1", description: "001", url: "bar-1.mp3", publish_date: Time.parse("01-01-2017 10:10:10")),
          double(:item, title: "foo-2", summary: "shorter-2", description: "002", url: "bar-2.mp3", publish_date: Time.parse("01-01-2017 11:10:10")),
        ]
      end

      before do
        allow_any_instance_of(EpisodeServices::Synchronize).to receive(:call)
          .with(items[0].title,
                items[0].summary,
                items[0].description,
                items[0].url,
                items[0].publish_date,
                channel).and_raise("InvalidEpisode")
      end

      it "ignore errors" do
        expect { service.call(items, channel) }.to_not raise_error("InvalidEpisode")
      end

      it "triggers the next episodes in the sequence" do
        expect(service).to receive(:synchronize).exactly(2).times

        service.call(items, channel)
      end
    end
  end
end
