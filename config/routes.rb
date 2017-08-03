Rails.application.routes.draw do
  mount API => "/"
  mount Sidekiq::Web => "/admin/jobs", as: "sidekiq_dashboard"
  mount Split::Dashboard => "/admin/experiments", as: "split_dashboard"
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"
end
