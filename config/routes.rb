NewKissr::Application.routes.draw do
  get 'dropbox/auth' => 'dropbox#auth'
  get 'dropbox/auth_callback' => 'dropbox#auth_callback'
  get '/signout', controller: :sessions, action: :destroy, as: :sign_out
  resources :sites, only: [:index, :new, :create, :destroy]
  resource :subscription, only: [:create, :new, :destroy]
  resources :domains, only: [:index]
  resource :account, only: :show
  root 'pages#show', id: 'home'
  get 'update', to: 'pages#show', id: 'update'
end
