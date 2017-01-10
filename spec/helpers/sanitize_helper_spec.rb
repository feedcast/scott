require "rails_helper"

RSpec.describe SanitizeHelper, type: :helper do
  describe "html_sanitize" do
    context "when the content has no html" do
      let(:input) do
        "This is not HTML content"
      end

      it "does not alter the content" do
        expect(helper.html_sanitize(input)).to eq(input)
      end
    end

    context "when the content has html" do
      context "with valid tags" do
        context "and no attributes" do
          let(:input) do
            "This is <b>HTML</b> content"
          end

          it "does not alter the content" do
            expect(helper.html_sanitize(input)).to eq(input)
          end
        end

        context "and valid atributes" do
          let(:input) do
            "This is <b>HTML</b> content"
          end

          it "does not alter the content" do
            expect(helper.html_sanitize(input)).to eq(input)
          end

          context "and the tag is a link" do
            let(:input) do
              "This is <a href=\"http://google.com\">HTML</a> content"
            end

            it "adds nofollow attribute" do
              expect(helper.html_sanitize(input)).to match(/nofollow/)
            end

            it "adds noopener attribute" do
              expect(helper.html_sanitize(input)).to match(/noopener/)
            end

            it "adds target blank attribute" do
              expect(helper.html_sanitize(input)).to match(/target="_blank">/)
            end
          end
        end

        context "and invalid attributes" do
          let(:input) do
            "This is <b class='foo'>HTML</b> content"
          end

          it "removes the invalid attributes" do
            expect(helper.html_sanitize(input)).to eq("This is <b>HTML</b> content")
          end
        end
      end

      context "with invalid tags" do
        let(:input) do
          "This is <div>HTML</div> content"
        end

        it "removes the div tag but keeps the content" do
          expect(helper.html_sanitize(input)).to eq("This is  HTML  content")
        end
      end
    end
  end

  describe "html clean" do
    let(:input) do
      "This is <div><a>HTML</a></div> content"
    end

    it "cleans all html from the input" do
      expect(helper.html_clean(input)).to eq("This is  HTML  content")
    end
  end
end
