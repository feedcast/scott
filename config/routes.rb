Rails.application.routes.draw do
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"

  get "/:channel", to: "channels#show"
  get "/:channel/:episode", to: "episodes#show"
end
