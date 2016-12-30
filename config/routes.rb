Rails.application.routes.draw do
  get "/:slug", to: "channels#show"
end
