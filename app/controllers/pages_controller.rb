class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:landing_page, :company_dashboard]
  before_action :authenticate_company!, only: [:company_dashboard]

  def search
    authorize current_user, :show?
    if params[:query]
      @results = PgSearch.multisearch(params[:query])
      @topics = @results.where(searchable_type: "Topic")
      @categories = @results.where(searchable_type: "Category")
      @articles = @results.where(searchable_type: "Article")

      respond_to do |format|
        format.html {}
        format.json {}
      end
    end
  end

  def landing_page
  end

  def dashboard
    authorize current_user, :show?
  end

  def author_dashboard
    authorize current_user
  end

  def company_dashboard
    authorize current_company
  end

  def exam_info
    @exam = CustomExam.find(params[:custom_exam_id])
    @first_flashcard = Flashcard.find(@exam.questions.first)
    authorize current_user, :show?
  end

end
