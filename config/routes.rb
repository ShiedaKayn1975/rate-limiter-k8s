Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get '/', to: 'hello#hello'

  namespace :api do
    resources :products, only: [:index]
  end
end
