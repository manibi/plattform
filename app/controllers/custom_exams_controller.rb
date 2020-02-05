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
    @exam.submit!

    @answers = @exam.custom_exam_answers
    @correct_answers = @exam.correct_answered_questions
    @wrong_answers   = @exam.questions.size - @correct_answers
    authorize @exam, :show?
  end
end
