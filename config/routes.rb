Rails.application.routes.draw do

  mount ForestLiana::Engine => '/forest'
  ActiveAdmin.routes(self)

  # ROOT TO LANDING WEBSITE
  root to: "pages#home"
  get 'about',                    to: 'pages#about'
  get 'notre_charte',             to: 'pages#charte'
  get 'cgu',                      to: 'pages#cgu'
  get 'charte_confidentialite',   to: 'pages#charte_confidentialite'
  get 'mentions_legales',         to: 'pages#mentions_legales'
  get 'info_business',            to: 'pages#info_business'
  get 'info_cause',               to: 'pages#info_cause'
  get 'faq',                      to: 'pages#faq'
  get 'faq_connect',              to: 'pages#faq_connect'
  get 'landing_business',         to: 'pages#landing_business'
  get 'landing_cause',            to: 'pages#landing_cause'
  put 'newsletter',               to: 'pages#newsletter'

  resources :contact_forms, only: [:new, :create]

  # ROOT TO APP CFORGOOD
  resources :businesses, only: [:index, :show]

  devise_scope :user do
    get "member/signup",          to: "devise/registrations#new"
    get "member/signin",          to: "devise/sessions#new"
    get "member/sent_mail",       to: "devise/passwords#sent_mail"
    put "member/update_cause",    to: "member/registrations#update_cause"
    put "member/update_profile",  to: "member/registrations#update_profile"
  end
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', passwords: :passwords }

  namespace :member do
    resources :users, only: [:show, :update] do
      get "dashboard", to: "dashboard#dashboard"
      get "profile", to: "dashboard#profile"
    end
    resources :signup, only: [:new, :create]
    resources :perks, only: [:show]
  end

  devise_for :businesses, path: :pro, controllers: {registrations: :registrations, passwords: :passwords}
  devise_scope :business do
    get "pro/sent_mail",        to: "pro/passwords#sent_mail"
    put "pro/update_business",  to: "pro/registrations#update_business"
  end

  namespace :pro do
    resources :businesses, only: [:show, :update] do
      resources :addresses
      resources :perks, only: [:index, :new, :create, :update]
      get 'dashboard',  to: 'dashboard#dashboard'
      get "profile",    to: "dashboard#profile"

    end
    resources :perks, only: [:show, :edit, :update, :destroy]
    resources :addresses, only: [:update]

    resources :activate, only: [:update, :destroy]
  end

  namespace :asso do
    resources :causes, only: [:index, :show]
    get 'dashboard', to: 'dashboard#dashboard'
  end

  resources :perks do
    resources :uses, only: [:create]
  end
end
