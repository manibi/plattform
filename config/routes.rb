Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'devise/registrations#update', :as => 'user_registration'
  end


  get 'profile', to: 'users#show'
  get 'profile/edit', to: 'users#edit'
  resources :users, only: :update

  resources :articles, only: [:index, :show]

  get 'welcome', to: 'pages#welcome'
  get 'dashboard', to: 'pages#dashboard'


  root to: 'pages#landing_page'
end
