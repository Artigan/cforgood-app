Rails.application.routes.draw do
  root to: "pages#home"

  devise_for :users

  get 'pages/home',     to: 'pages#home'
  get 'pages/business', to: 'pages#business'
  get 'pages/charity',  to: 'pages#charity'
  get 'pages/vision',   to: 'pages#vision'
end
