class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:landing_page]

  def search
    authorize current_user, :show?
    if params[:query]
      @results = PgSearch.multisearch(params[:query])
      # raise
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

  def exam_info
    @exam = CustomExam.find(params[:custom_exam_id])
    @first_flashcard = Flashcard.find(@exam.questions.first)
    authorize current_user, :show?
  end
end
