Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

  get '/sign_in' => 'pages#login', as: :sign_in
  devise_scope :user do
    delete '/sign_out' => 'devise/sessions#destroy', as: :sign_out
  end

  resources :courses, only: [:index, :new, :create, :show] do
    resources :weeks, only: [:show], param: :number do
      get   ':subject' => 'reflections#edit'
      patch ':subject' => 'reflections#update'
    end
  end

  resources :projects, only: [:index, :new, :create, :show, :edit, :update]

  scope :staff do
    get   '/' => 'staff#index'
    patch '/' => 'staff#update'
  end

  root to: 'pages#login'
end
