require "rails_helper"

RSpec.feature "Recent Channels", type: :feature do
  let!(:channels) do
    result = []
    30.times do |i|
      result << Fabricate(:channel, title: Faker::Hipster.sentence(3, true, 1), created_at: i.days.ago)
    end

    result
  end

  scenario "list the 24 most recent channels" do
    when_i_visit_the_recent_channels_page
    then_i_see_the_page_title
    then_i_see_a_list_with_the_most_recent_channels
  end

  private

  def when_i_visit_the_recent_channels_page
    visit "/channels/recent"
  end

  def then_i_see_the_page_title
    expect(page).to have_title("Channels - Page 1")
  end

  def then_i_see_a_list_with_the_most_recent_channels
    expect(page).to have_css(".channel a h3", count: 24)

    channels.first(12).each do |channel|
      expect(page).to have_selector(".channel a h3", text: channel.title)
    end
  end
end
