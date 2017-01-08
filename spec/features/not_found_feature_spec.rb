require "rails_helper"

RSpec.feature "Not found", type: :feature do
  scenario "as a user I access a 404 error page" do
    when_i_visit_an_invalid_page
    then_i_see_a_proper_error_page
  end

  private

  def when_i_visit_an_invalid_page
    visit "/not-valid-channel"
    @page = page
  end

  def then_i_see_a_proper_error_page
    expect(@page).to have_text("Page not found")
  end
end
