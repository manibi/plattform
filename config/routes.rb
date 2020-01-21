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
        post "answer_multiple_choice", to: "flashcards#answer_multiple_choice"
        post "answer_correct_order",   to: "flashcards#answer_correct_order"
        post "answer_match",           to: "flashcards#answer_match"
        post "input_numbers",          to: "flashcards#input_numbers"
        get "next_flashcard",          to: "flashcards#next_flashcard"
      end
    end
    get "quiz_results", to: "flashcards#results"
  end

  resources :flashcards, only: [:new, :create, :edit, :update, :destroy]

  get "welcome",   to: "pages#welcome"
  get "dashboard", to: "pages#dashboard"
  get "author_dashboard", to: "pages#author_dashboard"

  root to: "pages#landing_page"
end
