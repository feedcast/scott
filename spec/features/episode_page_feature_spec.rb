require "rails_helper"

RSpec.feature "Episode Page", type: :feature do
  let(:episode) { Fabricate(:episode, title: "My cool episode") }

  scenario "a user access an episode page" do
    when_i_visit_the_episode_by_its_slug
    and_the_pages_title_include_the_episode_title
  end

  def when_i_visit_the_episode_by_its_slug
    visit "/#{episode.channel.slug}/#{episode.slug}"
  end

  def and_the_pages_title_include_the_episode_title
    expect(page).to have_title("My cool episode | Feedcast")
  end
end
