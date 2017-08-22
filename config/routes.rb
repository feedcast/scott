Rails.application.routes.draw do
  # API
  mount API => "/"
  root to: redirect("/admin")

  # Jobs
  mount Sidekiq::Web => "/admin/jobs", as: "sidekiq_dashboard"

  # Admin
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"

  # GraphQL
  post "/graphql", to: "graphql#execute"
  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql" if Rails.env.development?
end
