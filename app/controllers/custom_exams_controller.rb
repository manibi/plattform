class CustomExamsController < ApplicationController
  before_action :authenticate_user!

  def show
    @exam = CustomExam.find(params[:id])
    authorize @exam
  end

  def results
    @exam = CustomExam.find(params[:custom_exam_id])
    authorize @exam, :show?
  end
end
