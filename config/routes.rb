Music::Application.routes.draw do


  scope :api do
    resources :tracks, defaults: {format: :json}
  end

  resources :bookmarks

  devise_for :users, :controllers => { omniauth_callbacks: "omniauth_callbacks" }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  resources :home, only: [:index, :create]
  resources :search, only: :index
  resources :artist, only: [:index,:show]
  resources :player, only: :index

  scope ":artist", as: "artist" do
    root to: 'artist#index'

    scope ":album", as: "album" do
      root to: 'album#index'
    end

    resources :album, only: [:index, :show]
  end


end
