Rails.application.routes.draw do
  resources :tweets, only: :create
end
