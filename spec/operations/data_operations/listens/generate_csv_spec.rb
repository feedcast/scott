require "rails_helper"

RSpec.describe DataOperations::Listens::GenerateCSV, type: :operation do
  let(:path) { "/tmp/#{SecureRandom.uuid}" }
  let(:operation) { DataOperations::Listens::GenerateCSV.new }
  let(:content) { File.read(path) }
  let(:header) { "user_id,episode_id,channel_id,started_at" }
  let(:perform!) { operation.call(target_path: path) }

  around :each do |example|
    perform!
    example.run
    FileUtils.rm(path)
  end

  context "when there are no listens" do
    it "writes the headers" do
      expect(content).to eq("#{header}\n")
    end
  end

  context "when there are listens" do
    let!(:listens) do
      [Fabricate(:episode_listen), Fabricate(:episode_listen)]
    end

    it "writes the full conten" do
      expect(content).to eq <<~CSV
        #{header}
        #{listens.first.user_id},#{listens.first.episode.uuid},#{listens.first.episode.channel.uuid},#{listens.first.started_at}
        #{listens.second.user_id},#{listens.second.episode.uuid},#{listens.second.episode.channel.uuid},#{listens.second.started_at}
      CSV
    end
  end
end
