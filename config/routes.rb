Rails.application.routes.draw do
  devise_for :users
  get 'pages/business', to: 'pages#business'
  get 'pages/charity', to: 'pages#charity'
  get 'pages/vision', to: 'pages#vision'
end
