Rails.application.routes.draw do

  ActiveAdmin.routes(self)
  get 'contact_form/new'
  get 'contact_form/create'

  root to: "pages#home"

  get 'notre_charte', to: 'pages#charte'
  get 'member_card', to: 'pages#member_card'
  get 'info_business', to: 'pages#info_business'
  get 'info_cause',  to: 'pages#info_cause'
  get 'about',   to: 'pages#about'

  get 'accounts', to: 'accounts#new'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :businesses, only: [:index, :show]

  resources :causes, only: [:index, :show]

  resources :contact_forms

  devise_for :businesses, path: :pro, controllers: {registrations: :registrations}
  namespace :pro do
    resources :businesses, only: [:show, :update] do
      resources :perks, only: [:index, :new, :create]
      get 'metrics', to: 'pages#home'
    end
    resources :perks, only: [:show, :edit, :update]
  end
end
