require 'api_constraints'

Music::Application.routes.draw do


  scope :api do
    resources :playitems, defaults: {format: :json}
    resources :playlists, defaults: {format: :json} do
      get :default, on: :collection
      get :load, on: :member
    end
    resources :tracks, defaults: {format: :json}
    resources :artists, defaults: {format: :json}
    resources :albums, defaults: {format: :json}
  end

  resources :bookmarks

  devise_for :users, :controllers => { sessions: "sessions", omniauth_callbacks: "omniauth_callbacks" }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  resources :top, only: :index
  resources :users, only: :index
  resources :home, only: [:index, :create]
  resources :search, only: :index
  resources :tag, only: :show
  resources :artist, only: [:index,:show]
  resources :player, only: :index
  resources :facebook, only: :index do
    post :fetch, on: :collection
  end


  scope ":artist", as: "artist" do
    root to: 'artist#index'

    scope ":album", as: "album" do
      root to: 'album#index'
    end

    resources :album, only: [:index, :show]
  end

  namespace :api, defaults: {format: :json} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: :true) do

      devise_scope :user do
        match '/sessions' => 'sessions#create', :via => :post
        match '/sessions' => 'sessions#destroy', :via => :delete
      end

      resources :record

      resources :users, only: [:create]
      match '/users' => 'users#show', :via => :get
      match '/users' => 'users#update', :via => :put
      match '/users' => 'users#destroy', :via => :delete
    end
  end

end
