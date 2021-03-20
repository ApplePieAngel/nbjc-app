Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :spaces, only: [:create, :index, :show, :update, :destroy] do
        resources :address
        resources :photos
        resources :space_indicators
        resources :space_languages
      end
      namespace :spaces do
        resources :reviews
      end
      
      resources :indicators
      resources :categories
      resources :users
    end
  end
end
