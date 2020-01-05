Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'devise/registrations#update', :as => 'user_registration'
  end

  get 'profile', to: 'users#show'
  get 'profile/edit', to: 'users#edit'
  resources :users, only: :update

  get 'dashboard', to: 'pages#dashboard'
  get 'welcome', to: 'pages#welcome'

  root to: 'pages#landing_page'
end
