require "rails_helper"

RSpec.feature "Search Channel", type: :feature do
  before do
    given_several_channels
    when_i_visit_the_home_page
    then_i_see_the_search_form
  end

  scenario "successful searching for a channel", js: true do
    and_i_search_for("nerd")
    then_i_see_the_expected_results
  end

  scenario "invalid search for a channel", js: true do
    and_i_search_for("Invalid")
    then_i_see_the_zero_results_message
  end

  private

  def given_several_channels
    Fabricate(:channel, title: "Nerd")
    Fabricate(:channel, title: "Nerdcast")
    Fabricate(:channel, title: "Paranerdia")
    Fabricate(:channel, title: "This is nerd")
    Fabricate(:channel, title: "NeRD")
    Fabricate(:channel, title: "My Podcast")
    Fabricate(:channel, title: "Alone")
    Fabricate(:channel, title: "Foo")
    Fabricate(:channel, title: "Bar")
  end

  def when_i_visit_the_home_page
    visit "/"
    @page = page
  end

  def then_i_see_the_search_form
    expect(@page).to have_css(search_form)
  end

  def and_i_search_for(term)
    @page.within(search_form) do
      fill_in "term", with: term
      input = @page.find("#search-input")
      input.set("#{term}")
      input.native.send_keys(:enter)
    end
    @page = page
  end

  def then_i_see_the_expected_results
    expect(@page).to have_css(".channel a h3", count: 5)

    expected = ["Nerd", "Nerdcast", "Paranerdia", "This is nerd", "NeRD"]

    expected.each do |channel|
      expect(@page).to have_selector(".channel a h3", text: channel)
    end
  end

  def then_i_see_the_zero_results_message
    expect(@page).to have_content("No Channels")
  end

  def search_form
    "#search-form"
  end
end
