require "rails_helper"

RSpec.feature "Recent Channels", type: :feature do
  scenario "list the 10 most recent channels" do
    given_several_channels
    when_i_visit_the_recent_channels_page
    then_i_see_a_list_with_the_10_most_recent_channels
  end

  private

  def given_several_channels
    15.times do |i|
      Fabricate(:channel, created_at: i.days.ago)
    end
  end

  def when_i_visit_the_recent_channels_page
    visit "/channels/recent"
    @page = page
  end

  def then_i_see_a_list_with_the_10_most_recent_channels
    recent_channels.each do |channel|
      expect(@page).to have_text(channel.title)
    end
  end

  def recent_channels
    Channel.all.order(created_at: :desc).limit(10)
  end
end
