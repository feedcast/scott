require "rails_helper"

RSpec.feature "Channels", type: :feature do
  let(:channel) { Fabricate(:channel) }

  scenario "user access a channel over the root route by slug" do
    visit "/#{channel.slug}"

    expect(page).to have_text(channel.title)
  end
end
