Rails.application.routes.draw do

  ActiveAdmin.routes(self)

  # ROOT TO LANDING WEBSITE
  root to: "pages#home"
  get 'notre_charte',  to: 'pages#charte'
  get 'member_card',   to: 'pages#member_card'
  get 'info_business', to: 'pages#info_business'
  get 'info_cause',    to: 'pages#info_cause'
  get 'about',         to: 'pages#about'
  get 'faq',           to: 'pages#faq'
  get 'landing_business', to: 'pages#landing_business'

  resources :contact_forms, only: [:new, :create]

  # ROOT TO APP CFORGOOD
  resources :businesses, only: [:index, :show]

  devise_for :users, path: :member, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  namespace :member do
    devise_scope :user do
      get "/signup" => "devise/registrations#new"
      get "/signin" => "devise/sessions#new"
    end
    resources :users, only: [:show, :update] do
      get 'dashboard', to: 'dashboard#dashboard'
      get "/user_profile" => "users#profile"
      put "/user_update_cause"  => "registrations#update_cause"
      put "/user_update_profile" => "registrations#update_profile"
    end
    resources :signup, only: [:new, :create]
    resources :perks, only: [:show]
  end

  devise_for :businesses, path: :pro, controllers: {registrations: :registrations}
  namespace :pro do
    devise_scope :business do
      get "/signup" => "devise/registrations#new"
      get "/signin" => "devise/sessions#new"
    end
    resources :businesses, only: [:show, :update] do
      resources :perks, only: [:index, :new, :create, :update]
      get 'dashboard', to: 'dashboard#dashboard'
    end
    resources :perks, only: [:show, :edit, :update]
  end

  namespace :cause do
    resources :causes, only: [:index, :show]
    get 'dashboard', to: 'dashboard#dashboard'
  end

  resources :perks do
    resources :uses, only: [:create]
  end
end
