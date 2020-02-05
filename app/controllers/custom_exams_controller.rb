class CustomExamsController < ApplicationController
  before_action :authenticate_user!

  def show
    @exam = CustomExam.find(params[:id])
    authorize @exam
  end

  # TODO:check autorisation
  def submit_exam
    @exam = CustomExam.find(params[:custom_exam_id])
    @questions = Flashcard.find(CustomExam.first.questions)
    authorize @exam, :show?
  end

  def results
    @exam = CustomExam.find(params[:custom_exam_id])
    authorize @exam, :show?
  end
end
