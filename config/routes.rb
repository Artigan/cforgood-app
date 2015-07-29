Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  get 'contact_form/new'

  get 'contact_form/create'

  root to: "pages#home"

  get 'member_card', to: 'pages#member_card'
  get 'info_business', to: 'pages#info_business'
  get 'info_cause',  to: 'pages#info_cause'
  get 'about',   to: 'pages#about'


  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :businesses, only: [:index, :show]

  resources :causes, only: [:index, :show]

  resources :contact_forms

end
