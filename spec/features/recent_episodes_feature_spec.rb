require "rails_helper"

RSpec.feature "Recent Episodes", type: :feature do
  scenario "list the 24 most recent episodes" do
    given_several_episodes
    when_i_visit_the_recent_episodes_page
    then_i_see_a_list_with_the_most_recent_episodes
  end

  private

  def given_several_episodes
    @episodes = []

    30.times do |i|
      @episodes << Fabricate(:episode, title: Faker::Hipster.sentence(5, true, 2), published_at: i.days.ago)
    end
  end

  def when_i_visit_the_recent_episodes_page
    visit "/episodes/recent"
    @page = page
  end

  def then_i_see_a_list_with_the_most_recent_episodes
    expect(@page).to have_css(".episode a h3", count: 24)

    @episodes.first(12).each do |episode|
      expect(@page).to have_selector(".episode a h3", text: episode.title)
    end
  end
end
