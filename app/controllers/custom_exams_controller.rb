class CustomExamsController < ApplicationController
  before_action :authenticate_user!

  def new
    @exam = CustomExam.new
    authorize @exam
  end

  def show
    @exam = CustomExam.find(params[:id])
    authorize @exam
  end

  def create
    @exam = CustomExam.new(user: current_user)
    authorize @exam, :new?
    if exam_params
      articles = exam_params[:article_ids]
      @exam.questions = CustomExam.exam_questions_from(articles).pluck(:id)
    end

    if @exam.save
      # redirect_to @exam
      redirect_to custom_exam_info_path(@exam)
    else
      render :new
    end
  end

  def submit_exam
    @exam = CustomExam.find(params[:custom_exam_id])
    @questions = @exam.all_questions
    authorize @exam, :show?
  end

  def results
    @exam = CustomExam.find(params[:custom_exam_id])
    @exam.submit!
    @questions = @exam.all_questions

    @answers = @exam.custom_exam_answers
    @correct_answers = @exam.correct_answered_questions
    @wrong_answers   = @exam.questions.size - @correct_answers
    authorize @exam, :show?
  end

  def add_exam_categories
    @exam = CustomExam.new
    authorize @exam, :new?
    @add_categories = exam_topics_params.include? "topic_id"
    @topic = Topic.find(params[:id].split("_").last)

    respond_to do |format|
        format.js
    end
  end

  def add_exam_articles
    @exam = CustomExam.new
    authorize @exam, :new?
    @add_articles = exam_categories_params.include? "category_id"
    @category = Category.find(params[:id].split("_").last)

    respond_to do |format|
        format.js
    end
  end

  private

  def exam_topics_params
    if params[:exam]
      params.require(:exam).permit(:topic_id)
    else
      params.permit(:id)
    end
  end

  def exam_categories_params
    if params[:exam]
      params.require(:exam).permit(:category_id)
    else
      params.permit(:id)
    end
  end

  def exam_params
    params.require(:exam).permit(article_ids: []) if params[:exam]
  end
end
