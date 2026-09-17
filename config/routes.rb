Rails.application.routes.draw do

  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  resources :tweets
  resources :tags, only: [:destroy]

  get 'baseball', to: 'sports#baseball'
  get 'soccer', to: 'sports#soccer'
  get 'basketball', to: 'sports#basketball'

  root 'tweets#index'

end