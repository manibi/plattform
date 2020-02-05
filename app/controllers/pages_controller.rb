class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard, :author_dashboard]

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
