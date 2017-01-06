require "rails_helper"

RSpec.feature "Episodes", type: :feature do
  let(:episode) { Fabricate(:episode) }

  scenario "user access a episode over the channel by slug" do
    visit "/#{episode.channel.slug}/#{episode.slug}"

    expect(page).to have_text(episode.title)
  end
end
