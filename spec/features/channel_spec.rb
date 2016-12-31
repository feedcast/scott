require "rails_helper"

RSpec.feature "Channels", type: :feature do
  let!(:channel) { Channel.create(name: "Bar", slug: "bar") }

  scenario "user access a channel over the root route by slug" do
    visit "/bar"

    expect(page).to have_text(channel.name)
  end
end
