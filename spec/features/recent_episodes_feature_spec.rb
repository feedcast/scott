require "rails_helper"

RSpec.feature "Recent Episodes", type: :feature do
  scenario "list the 10 most recent episodes" do
    given_several_episodes
    when_i_visit_the_recent_episodes_page
    then_i_see_a_list_with_the_10_most_recent_episodes
  end

  private

  def given_several_episodes
    15.times do |i|
      Fabricate(:episode, published_at: i.hours.ago)
    end
  end

  def when_i_visit_the_recent_episodes_page
    visit "/episodes/recent"
    @page = page
  end

  def then_i_see_a_list_with_the_10_most_recent_episodes
    recent_episodes.each do |episode|
      expect(@page).to have_text(episode.title)
    end
  end

  def recent_episodes
    Episode.all.order(published_at: :desc).limit(10)
  end
end
