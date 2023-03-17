Rails.application.routes.draw do
  root "search#root"

  post '/search', to: 'search#search'
  get '/search', to: 'search#search'
end
