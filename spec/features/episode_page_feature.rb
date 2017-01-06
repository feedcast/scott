require "rails_helper"

RSpec.feature "Episodes", type: :feature do
  let(:channel) { Channel.create!(title: "Foo") }
  let!(:episode) { Episode.create!(title: "Bar", url: "blank.mp3", published_at: Time.now, channel: channel) }

  scenario "user access a episode over the channel by slug" do
    visit "/foo/bar"

    expect(page).to have_text(episode.title)
  end
end
