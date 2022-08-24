Rails.application.routes.draw do
  root to: 'questions#index'

  resources :questions
  resource :session, only: %i[new create destroy]
  resources :users, param: :nickname
  resources :hashtags, only: %i[show], param: :name
end
