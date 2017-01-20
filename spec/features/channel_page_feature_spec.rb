require "rails_helper"

RSpec.feature "Channel", type: :feature do
  let!(:channel) { Fabricate(:channel_with_episodes, title: "Dr. House Podcast") }

  scenario "user access a channel" do
    when_i_visit_the_channel_page
    then_i_see_the_channel_title
    and_the_pages_title_include_the_channel
    and_the_list_of_episodes
  end

  private

  def when_i_visit_the_channel_page
    visit "/#{channel.slug}"
  end

  def then_i_see_the_channel_title
    expect(page).to have_text(channel.title)
  end

  def and_the_list_of_episodes
    channel.episodes.each do |episode|
      expect(page).to have_text(episode.title)
    end
  end

  def and_the_pages_title_include_the_channel
    expect(page).to have_title("Dr. House Podcast | Feedcast")
  end
end
