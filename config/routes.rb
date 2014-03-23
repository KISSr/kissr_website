NewKissr::Application.routes.draw do
  get '/oauth2/callback', controller: :sessions, action: :create
  get '/signout', controller: :sessions, action: :destroy, as: :sign_out
  resources :sites, only: [:index, :new, :create]
  root 'pages#show', id: 'home'
end
