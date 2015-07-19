Rails.application.routes.draw do
  root to: "pages#home"

  get 'pages/business', to: 'pages#business'
  get 'pages/charity',  to: 'pages#charity'
  get 'pages/how_it_works',   to: 'pages#how_it_works'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

end
