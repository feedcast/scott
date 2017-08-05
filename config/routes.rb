Rails.application.routes.draw do
  mount API => "/"
  mount Sidekiq::Web => "/admin/jobs", as: "sidekiq_dashboard"
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"

  root to: redirect("/admin")
end
