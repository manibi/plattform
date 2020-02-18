Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'devise/registrations#update', :as => 'user_registration'
  end

  get 'profile',      to: 'users#show'
  get 'profile/edit', to: 'users#edit'

  resources :users,      only:    :update
  resources :topics,     except:  :destroy
  resources :categories, except:  :destroy

  resources :articles,   except:  :destroy do
    member do
      post  "read"
      # TODO! remove unread - just for testing
      patch "unread"
      post  "bookmark"
      patch "unbookmark"
      get "flashcards"
    end

    resources :flashcards, only: :show do
      member do
        post "answer_multiple_choice", to: "flashcards#answer_multiple_choice"
        post "answer_correct_order",   to: "flashcards#answer_correct_order"
        post "answer_match",           to: "flashcards#answer_match"
        post "soll_ist",               to: "flashcards#soll_ist"
        get  "next_flashcard",         to: "flashcards#next_flashcard"
      end
    end
    get "quiz_results", to: "flashcards#results"
  end

  resources :flashcards, only: [:index, :new, :create, :edit, :update, :destroy]

  get "add_exam_categories", to: "custom_exams#add_exam_categories"
  get "add_exam_articles",   to: "custom_exams#add_exam_articles"

  resources :custom_exams, only: [:new, :create, :show], path: "exams" do
    get "results",      to: "custom_exams#results"
    get "submit_exam",  to: "custom_exams#submit_exam"
    get "info",         to: "pages#exam_info"

    resources :flashcards, only: :show do
      member do
        post "answer_multiple_choice", to: "flashcards#answer_multiple_choice"
        post "answer_correct_order",   to: "flashcards#answer_correct_order"
        post "answer_match",           to: "flashcards#answer_match"
        post "soll_ist",               to: "flashcards#soll_ist"
        post  "bookmark",              to: "flashcards#bookmark"
        patch "unbookmark",            to: "flashcards#unbookmark"
      end
    end
  end

  get "welcome",          to: "pages#welcome"
  get "dashboard",        to: "pages#dashboard"
  get "author_dashboard", to: "pages#author_dashboard"
  get "search",           to: "pages#search"

  root to: "pages#landing_page"
end
