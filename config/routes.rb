Gifutu2::Application.routes.draw do
  get '/list' => 'gifs#list'
  get '/unapproved' => 'gifs#unapproved'
  #get 'gifs/:id/approve', to: 'gifs#approve'
  resources :gifs do
  	member do
    	get 'approve'
    	get 'reject'
    	get 'delete'
    	get 'undelete'
  	end
  end


  get 'tags/:tag', to: 'gifs#index', as: :tag

  root :to => "gifs#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
end