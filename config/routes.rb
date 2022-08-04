Rails.application.routes.draw do
  root to: 'questions#index'

  resources :questions do
    member do
      put 'hide', to: 'questions#hidden'
    end
  end
end
