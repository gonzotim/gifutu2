Gifutu2::Application.routes.draw do
  resources :gifs
  get 'tags/:tag', to: 'gifs#index', as: :tag

  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
end