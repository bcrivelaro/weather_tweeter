Rails.application.routes.draw do
  resources :tweet, only: :create
end
