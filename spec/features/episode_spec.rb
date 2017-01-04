require "rails_helper"

RSpec.feature "Episodes", type: :feature do
  let(:episodes) { [ Episode.new(title: "Bar", url: "blank.mp3", published_at: Time.now) ] }
  let(:episode) { channel.episodes.first }
  let(:channel) { Channel.create(title: "Foo", slug: "bar", episodes: episodes) }

  scenario "user access a episode over the channel by slug and uuid" do
    visit "/bar/#{episode.uuid}"

    expect(page).to have_text(episode.title)
  end
end
