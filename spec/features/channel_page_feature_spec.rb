require "rails_helper"

RSpec.feature "Channels", type: :feature do
  scenario "display channel's information and list of episodes" do
    given_a_channel
    when_i_visit_the_channel_page
    then_i_see_the_channel_title
    and_the_list_of_episodes
  end

  private

  def given_a_channel
    @channel = Fabricate(:channel_with_episodes)
  end

  def when_i_visit_the_channel_page
    visit "/#{@channel.slug}"
    @page = page
  end

  def then_i_see_the_channel_title
    expect(@page).to have_text(@channel.title)
  end

  def and_the_list_of_episodes
    @channel.episodes.each do |episode|
      expect(@page).to have_text(episode.title)
    end
  end
end
