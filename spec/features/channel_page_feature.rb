require "rails_helper"

RSpec.feature "Channels", type: :feature do
  let!(:channel) { Channel.create!(title: "Foo") }

  scenario "user access a channel over the root route by slug" do
    visit "/foo"

    expect(page).to have_text(channel.title)
  end
end
