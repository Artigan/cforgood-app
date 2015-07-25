Rails.application.routes.draw do
  get 'contact_form/new'

  get 'contact_form/create'

  root to: "pages#home"

  get 'business', to: 'pages#business'
  get 'charity',  to: 'pages#charity'
  get 'about',   to: 'pages#about'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :businesses, only: [:index, :show]

  resources :causes, only: [:index, :show]

  resources :contact_forms
end
