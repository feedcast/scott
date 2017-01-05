
Rails.application.routes.draw do
  mount Split::Dashboard => "/admin/experiments", as: "split_dashboard"
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"

  get "/:channel", to: "channels#show"
  get "/:channel/:episode", to: "episodes#show"
end
