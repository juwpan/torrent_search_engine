Rails.application.routes.draw do
  # root "search#search"

  root "search#root"
  post '/search', to: 'search#search'

  # resources :search
end
