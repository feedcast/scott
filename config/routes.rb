Rails.application.routes.draw do
  mount Split::Dashboard => "/admin/experiments", as: "split_dashboard"
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"

  root "channels#list"

  get "/channels/recent", to: "channels#list", as: "channels"
  get "/episodes/recent", to: "episodes#list", as: "episodes"

  get "/:channel", to: "channels#show", as: "channel"
  get "/:channel/:episode", to: "episodes#show", as: "episode"
end
