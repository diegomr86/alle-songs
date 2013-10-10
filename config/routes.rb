Music::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  resources :home, only: :index
  resources :artist, only: [:index,:show]
  resources :player, only: :index

  scope ":artist", as: "artist" do
    root to: 'artist#index'
  end


end