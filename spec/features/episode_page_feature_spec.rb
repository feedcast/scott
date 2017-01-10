require "rails_helper"

RSpec.feature "Episode", type: :feature do
  scenario "user access an episode" do
    given_an_episode
    when_i_visit_the_episode_by_its_slug
    then_i_see_the_episode_attributes
    and_the_pages_title_include_the_episode_title
  end

  def given_an_episode
    @episode = Fabricate(:episode, title: "My cool episode")
  end

  def when_i_visit_the_episode_by_its_slug
    visit "/#{@episode.channel.slug}/#{@episode.slug}"

    @page = page
  end

  def then_i_see_the_episode_attributes
    expect(@page).to have_text("My cool episode")
  end

  def and_the_pages_title_include_the_episode_title
    expect(@page).to have_title("My cool episode | Feedcast")
  end
end
