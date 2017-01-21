require "rails_helper"

RSpec.describe FontAwesome::Icon do
  describe "to_html" do
    let(:icon) do
      FontAwesome::Icon.new("foo")
    end

    it "returns the icon's html" do
      expect(icon.to_html).to eq("<i class=\"fa fa-foo\"></i>")
    end
  end
end
