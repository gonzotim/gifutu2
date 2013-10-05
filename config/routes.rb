Gifutu2::Application.routes.draw do
  resources :gifs

  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
end