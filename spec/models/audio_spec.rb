require "rails_helper"

RSpec.describe Audio do
  let(:audio) { Fabricate(:episode).audio }

  describe "status" do
    it "defaults to new" do
      expect(audio.status).to eq(:new)
    end

    describe "analyse!" do
      before do
        audio.analyse!
      end

      it "sets the status to analysed" do
        expect(audio).to be_analysed
      end

      it "sets the analysed at date to now" do
        expect(audio.analysed_at).to be_between(1.second.ago, Time.now)
      end

      it "cleans the failure message" do
        expect(audio.error_message).to be_empty
      end
    end

    describe "failure!" do
      before do
        audio.fail!("Audio is invalid!")
      end

      it "sets the status to failed" do
        expect(audio).to be_failed
      end

      it "sets analysed at date to now" do
        expect(audio.analysed_at).to be_between(1.second.ago, Time.now)
      end

      it "stores the reason for the failure" do
        expect(audio.error_message).to eq("Audio is invalid!")
      end
    end
  end
end
