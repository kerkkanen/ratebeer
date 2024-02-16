Rails.application.routes.draw do
  resources :memberships
  resources :beer_clubs
  resources :beers
  resources :ratings, only: [:index, :show, :new, :create, :destroy]
  resource :session, only: [:new, :create, :destroy]
  resources :places, only: [:index, :show]
  resources :styles
  resources :breweries do
    post 'toggle_activity', on: :member
    get 'active', on: :collection
    get 'retired', on: :collection
  end
  resources :users do
    post 'toggle_activity', on: :member
    get 'recommendation', on: :member
  end
  resources :memberships do
    post 'accept', on: :member
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'breweries#index'
  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  get 'join_club', to: 'memberships#new'
  delete 'signout', to: 'sessions#destroy'
  post 'places', to: 'places#search'
  get 'beerlist', to: 'beers#list'
  get 'brewerylist', to: 'breweries#list'

end
