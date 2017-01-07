require "rails_helper"

RSpec.feature "Recent Channels", type: :feature do
  scenario "list the 12 most recent channels" do
    given_several_channels
    when_i_visit_the_recent_channels_page
    then_i_see_a_list_with_the_12_most_recent_channels
  end

  private

  def given_several_channels
    @channels = []

    15.times do |i|
      @channels << Fabricate(:channel, title: Faker::Hipster.sentence(3, true, 1), created_at: i.days.ago)
    end
  end

  def when_i_visit_the_recent_channels_page
    visit "/channels/recent"
    @page = page
  end

  def then_i_see_a_list_with_the_12_most_recent_channels
    expect(@page).to have_css(".channel a h3", count: 12)

    @channels.first(12).each do |channel|
      expect(@page).to have_selector(".channel a h3", text: channel.title)
    end
  end
end
