Rails.application.routes.draw do
  root to: "pages#home"

  get 'business', to: 'pages#business'
  get 'charity',  to: 'pages#charity'
  get 'how_it_works',   to: 'pages#how_it_works'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :businesses, only: [:index, :show]

  resources :causes, only: [:index, :show]

end
