Rails.application.routes.draw do
  root "search#new"

  resources :search
end
