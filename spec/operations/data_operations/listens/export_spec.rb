require "rails_helper"

RSpec.describe DataOperations::Listens::Export, type: :operation do
  let(:operation) { DataOperations::Listens::Export.new }
  let(:perform) { operation.perform }
  let(:tmp_file) { double(:tmpfile, path: tmp_path) }
  let(:tmp_path) { "/foo/123d" }

  before do
    allow(Tempfile).to receive(:new).and_return(tmp_file)
    allow_any_instance_of(DataOperations::Listens::Export).to receive(:run).with(DataOperations::Listens::GenerateCSV, any_args).and_return(true)
    allow_any_instance_of(DataOperations::Listens::Export).to receive(:run).with(DataOperations::Upload, any_args).and_return(true)
  end

  it "triggers the csv generation"  do
    expect_any_instance_of(DataOperations::Listens::Export).to receive(:run).with(DataOperations::Listens::GenerateCSV, target_path: tmp_path)

    perform
  end

  it "triggers the upload" do
    expect_any_instance_of(DataOperations::Listens::Export).to receive(:run).with(DataOperations::Upload, local_path: tmp_path, remote_path: "data-science/episode-listens.csv")

    perform
  end
end
