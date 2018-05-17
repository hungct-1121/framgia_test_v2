Rails.application.routes.draw do
  root "exams#index"
  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"

  resources :users do
    resources :questions
  end
  resources :exams, only: [:index, :show, :create, :update]
  resources :subjects, only: :show
end
