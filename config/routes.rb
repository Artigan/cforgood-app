Rails.application.routes.draw do

  ActiveAdmin.routes(self)
  get 'contact_form/new'
  get 'contact_form/create'

  root to: "pages#home"

  get 'notre_charte',  to: 'pages#charte'
  get 'member_card',   to: 'pages#member_card'
  get 'info_business', to: 'pages#info_business'
  get 'info_cause',    to: 'pages#info_cause'
  get 'about',         to: 'pages#about'

  get 'landing_business', to: 'pages#landing_business'

  resources :accounts, only: [:new, :create]

  devise_scope :user do
    get "/signup" => "devise/registrations#new"
    get "/signin" => "devise/sessions#new"
    put "/users"  => "registrations#update"
    put "/update_cause"  => "registrations#update_cause"
  end

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  get 'dashboard', to: "dashboard#dashboard"

  resources :businesses, only: [:index, :show]

  resources :causes, only: [:index, :show]

  resources :contact_forms

  resources :perks do
    resources :uses, only: [:create]
  end

  devise_for :businesses, path: :pro, controllers: {registrations: :registrations}
  namespace :pro do
    resources :businesses, only: [:show, :update] do
      resources :perks, only: [:index, :new, :create, :update]
      get 'metrics', to: 'pages#home'
    end
    resources :perks, only: [:show, :edit, :update]
  end
end
