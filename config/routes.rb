Rails.application.routes.draw do
#   devise_for :companies, controllers: {
#     sessions: 'companies/sessions',
#     passwords: 'companies/passwords',
#     registrations: 'companies/registrations'
# }
#   devise_for :users, controllers: {
#     sessions: 'users/sessions',
#     passwords: 'users/passwords',
#     registrations: 'users/registrations'
# }

  devise_for :companies, skip: [:registrations]
  as :company do
    get 'companies/edit' => 'companies/registrations#edit', :as => 'edit_company_registration'
    put 'companies' => 'companies/registrations#update', :as => 'company_registration'
  end

  devise_for :users, skip: [:registrations]
  as :user do
    get 'users/edit' => 'users/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'users/registrations#update', :as => 'user_registration'
  end

  resources :users,           only: [:new, :create, :update]
  get 'profile',              to: 'users#show'
  get 'profile/edit',         to: 'users#edit'

  get 'new_author',           to: 'users#new_author'
  post 'generate_author',     to: 'users#generate_author'
  get 'new_student',          to: 'users#new_student'
  post 'generate_student',    to: 'users#generate_student'

  resources :companies,       only: [:new, :create, :update]
  get 'company/profile',      to: 'companies#show'
  get 'company/profile/edit', to: 'companies#edit'
  get "company/:user_id",     to: "companies#user_details", as: :company_user
  get "company_dashboard",    to: "companies#company_dashboard"

  resources :topics
  resources :categories
  resources :professions
  resources :temporary_user_credentials, only: [:new, :create]

  resources :articles do
    member do
      post  "read"
      get   "read_next"
      post   "read_next"
      # TODO! remove unread - just for testing
      # patch "unread"
      post  "bookmark"
      patch "unbookmark"
      post  "publish"
      patch "unpublish"
      get "flashcards"
    end

    resources :flashcards, only: :show do
      member do
        post "answer_multiple_choice", to: "flashcards#answer_multiple_choice"
        post "answer_correct_order",   to: "flashcards#answer_correct_order"
        post "answer_match",           to: "flashcards#answer_match"
        post "soll_ist",               to: "flashcards#soll_ist"
        get  "next_flashcard",         to: "flashcards#next_flashcard"
        post  "publish"
        patch "unpublish"
      end
    end
    get "quiz_results", to: "flashcards#results"
  end

  resources :flashcards, except: :show

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

  get "welcome",            to: "pages#welcome"
  get "dashboard",          to: "pages#dashboard"
  get "author_dashboard",   to: "pages#author_dashboard"
  get "admin_dashboard",    to: "pages#admin_dashboard"
  get "admin_professions",  to: "pages#admin_professions"
  get "admin_topics",       to: "pages#admin_topics"
  get "admin_categories",   to: "pages#admin_categories"
  get "search",             to: "pages#search"
  get "temp_user_success",  to: "pages#temporary_user_info"

  root to: "pages#landing_page"
end
