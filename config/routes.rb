Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'devise/registrations#update', :as => 'user_registration'
  end


  get 'profile', to: 'users#show'
  get 'profile/edit', to: 'users#edit'
  resources :users, only: :update

  resources :articles, only: [:index, :show] do
    member do
      post  "read"
      # TODO! remove unread - just for testing
      patch "unread"
      post  "bookmark"
      patch "unbookmark"
    end

    resources :flashcards, only: :show do
      member do
        post "answer", to: "flashcards#answer"
      end
    end
    get "quiz_results", to: "flashcards#results"
  end

  get "welcome", to: "pages#welcome"
  get "dashboard", to: "pages#dashboard"


  root to: "pages#landing_page"
end
