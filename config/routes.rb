  Rails.application.routes.draw do

  ActiveAdmin.routes(self)

  # ROOT TO LANDING WEBSITE
  root to: "pages#home"
  get 'notre_charte',     to: 'pages#charte'
  get 'member_card',      to: 'pages#member_card'
  get 'info_business',    to: 'pages#info_business'
  get 'info_cause',       to: 'pages#info_cause'
  get 'about',            to: 'pages#about'
  get 'faq',              to: 'pages#faq'
  get 'landing_business', to: 'pages#landing_business'

  resources :contact_forms, only: [:new, :create]

  # ROOT TO APP CFORGOOD
  resources :businesses, only: [:index, :show]

  devise_for :users, path: :member, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    get "member/signup", to: "devise/registrations#new"
    get "member/signin", to: "devise/sessions#new"
    put "member/update_cause", to: "member/registrations#update_cause"
    put "member/update_profile", to: "member/registrations#update_profile"
  end
  namespace :member do
    resources :users, only: [:show, :update] do
      get "dashboard", to: "dashboard#dashboard"
      get "profile", to: "dashboard#profile"
    end
    resources :signup, only: [:new, :create]
    resources :perks, only: [:show]
  end

  devise_for :businesses, path: :pro, controllers: {registrations: :registrations}
  devise_scope :business do
    get "pro/signup", to: "devise/registrations#new"
    get "pro/signin", to: "devise/sessions#new"
  end
  namespace :pro do
    resources :businesses, only: [:show, :update] do
      resources :perks, only: [:index, :new, :create, :update]
      get 'dashboard', to: 'dashboard#dashboard'
    end
    resources :perks, only: [:show, :edit, :update]
  end

  namespace :asso do
    resources :causes, only: [:index, :show]
    get 'dashboard', to: 'dashboard#dashboard'
  end

  resources :perks do
    resources :uses, only: [:create]
  end
end
