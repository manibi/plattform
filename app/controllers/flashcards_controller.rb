class FlashcardsController < ApplicationController
  before_action :authenticate_user!

  # TODO: check for floats input not only integers - table quiz soll_ist

  # Play article flashcards
  def index
    @articles = policy_scope(Flashcard)
  end

  def new
    @flashcard = Flashcard.new
    authorize @flashcard
    @articles = current_user.all_articles
    # @flashcard.answers.build
  end

  def show
    @flashcard = Flashcard.find(params[:id])
    authorize @flashcard
    @article = @flashcard.article

    if @flashcard.flashcard_type == "match_answers"
      @dragabble_answers  = Answer.find(@flashcard.correct_answers)
      @static_answers     = Answer.find(@flashcard.answers.pluck(:id) - @flashcard.correct_answers)
    end

    if @flashcard.flashcard_type == "table_quiz"
    @table_headings = @flashcard.answers.pluck(:content).select { |v| v =~ /\D/ }
    @table_answer_rows =  @flashcard.correct_answers.each_slice(4).to_a
    end

    if !request.path.include? "exams"
      @article.read_for!(current_user) unless @article.read_for?(current_user)

      # Reset flashcards for this article if re-taking the quiz
      if @article.flashcards.sort.first == @flashcard && current_user.correct_answered_flashcards_for(@article).count == @article.flashcards.count
        Flashcard.reset_for!(current_user, @article)
      end
    end
  end

  def create
    @new_flashcard = Flashcard.new
    authorize @new_flashcard

    @article_id = new_flashcard_params.delete("article").to_i
    @article = Article.find(@article_id)
    flashcard_params = new_flashcard_params.except(:article)
    @flashcard = @article.flashcards.build(flashcard_params)

    if @flashcard.save
      # raise
      set_correct_answers if %w[match_answers soll_ist table_quiz].include? @flashcard.flashcard_type

      # set_correct_answers if @flashcard.flashcard_type == "match_answers"
      flash[:notice] = "Flashcard created"
      redirect_to edit_flashcard_path(@flashcard)
    else
      render :new
    end
  end

  def edit
    @flashcard = Flashcard.find(params[:id])
    @articles = current_user.all_articles

    authorize @flashcard
  end

  def update
    @flashcard = Flashcard.find(params[:id])
    authorize @flashcard

    flashcard_params = new_flashcard_params
    flashcard_params[:article] = Article.find(flashcard_params[:article])

    if @flashcard.flashcard_type == "correct_order"
      flashcard_params[:correct_answers] = flashcard_params[:correct_answers].map { |order| @flashcard.answers[order.to_i - 1].id }
    end

    if @flashcard.update(flashcard_params)
      set_correct_answers if %w[match_answers soll_ist table_quiz].include? @flashcard.flashcard_type

      # raise
      flash[:notice] = "Flashcard updated"
      redirect_to edit_flashcard_path(@flashcard)
    else
      render :edit
    end
  end

  # user selects answer
  # send form
  # check answser
  # render form again with disabled fields and no submit button
  # show right answers - feedback on how he did
  # render btn to next_flashcard
  def answer_multiple_choice
    @flashcard = Flashcard.find(params[:id])
    authorize @flashcard, :show?

    @article = @flashcard.article
    @correct_answers = @flashcard.correct_answers.sort.map(&:to_i)

    if set_multiple_choice_answer
      @answers = set_multiple_choice_answer[:answer_ids].map(&:to_i)
      @user_answer = @answers.sort ==  @correct_answers
    else
      @user_answer = false
    end

    if request.path.include? "exams"
      @exam = CustomExam.find(params[:custom_exam_id])
      # save exam answer
      # @flashcard.save_exam_answer_for!(current_user, @user_answer)
      # redirect to next flashcard
      next_exam_flashcard(@exam)
    else
      @flashcard.save_answer_for!(current_user, @user_answer)
      render "flashcards/show"
    end
  end

  def answer_correct_order
    @flashcard = Flashcard.find(params[:id])
    authorize @flashcard, :show?
    @article = @flashcard.article

    if @flashcard.flashcard_type == 'match_answers'
      @dragabble_answers  = Answer.find(@flashcard.correct_answers)
      @static_answers     = Answer.find(@flashcard.answers.pluck(:id) - @flashcard.correct_answers)
    end

    # Check answers
    @answers = set_correct_order_answer.to_h.keys.map(&:to_i)
    @user_answer = @flashcard.correct_answers == @answers

    if request.path.include? "exams"
      @exam = CustomExam.find(params[:custom_exam_id])
      # save exam answer
      # @flashcard.save_exam_answer_for!(current_user, @user_answer)
      # redirect to next flashcard
      next_exam_flashcard(@exam)
    else
      @flashcard.save_answer_for!(current_user, @user_answer)
      render "flashcards/show"
    end
  end

  def soll_ist
    @flashcard = Flashcard.find(params[:id])
    authorize @flashcard, :show?
    @article = @flashcard.article

    # Check answers
    @answers = set_correct_order_answer.to_h.values.map(&:to_i)
    @user_answer = @flashcard.correct_answers == @answers
    @table_headings = @flashcard.answers.pluck(:content).select { |v| v =~ /\D/ }
    @table_answer_rows =  @flashcard.correct_answers.each_slice(4).to_a

    if request.path.include? "exams"
      @exam = CustomExam.find(params[:custom_exam_id])
      # save exam answer
      # @flashcard.save_exam_answer_for!(current_user, @user_answer)
      # redirect to next flashcard
      next_exam_flashcard(@exam)
    else
      @flashcard.save_answer_for!(current_user, @user_answer)
      render "flashcards/show"
    end
  end

  # def result
  #   @flashcard = Flashcard.find(params[:id])
  #   @article = @flashcard.article
  # end

  def results
    @article = Article.find(params[:article_id])
    authorize @article, :show?

    @upcoming_articles = policy_scope(Article)
    @all_answered_flashcards = current_user.answered_flashcards_for(@article)
    @tries = current_user.user_flashcards_for(@article).pluck(:tries).sum

    # Next article to read
    if @upcoming_articles.empty?
      @next_article = current_user.profession
                                  .topics.first
                                  .categories.first
                                  .articles.first
    else
      @next_article = @upcoming_articles.first
    end

    render "flashcards/results"
  end

  # Return next flashcard or flashcard results
  def next_flashcard
    @flashcard = Flashcard.find(params[:id])
    authorize @flashcard, :show?

    @article = @flashcard.article
    @wrong_answered_flashcards = current_user.wrong_answered_flashcards_for(@article)
    @correct_answered_flashcards = current_user.correct_answered_flashcards_for(@article)
    flashcards_to_do = @article.flashcards.sort

    if flashcards_to_do.last != @flashcard && !current_user.answered?(flashcards_to_do.last)
      @next_flashcard = flashcards_to_do[flashcards_to_do.index(@flashcard) + 1]
    else
      @next_flashcard = @wrong_answered_flashcards.sample
    end

    if @correct_answered_flashcards.count == flashcards_to_do.count
      redirect_to article_quiz_results_path(@article)
    else
      redirect_to article_flashcard_path(@article, @next_flashcard)
    end
  end

  private

  def set_multiple_choice_answer
    params.require(:flashcard).permit(answer_ids: []) if params[:flashcard]
  end

  def set_correct_order_answer
    @flashcard = Flashcard.find(params[:id])
    params.require(:flashcard).require(:answer).permit! if params[:flashcard]
  end

  def new_flashcard_params
    params.require(:flashcard).permit(:article, :image, :flashcard_type, :content, correct_answers: [], answers_attributes: Answer.attribute_names.map(&:to_sym).push(:_destroy))
  end

  def set_correct_answers
    if @flashcard.flashcard_type == "match_answers"
      correct_answers = @flashcard.answers.pluck(:id).select.with_index { |id, i| id if i.odd? }
    elsif @flashcard.flashcard_type == "soll_ist"
      correct_answers = @flashcard.answers.pluck(:content).map(&:to_i)
    else
      correct_answers = @flashcard.answers.pluck(:content).select { |v| v =~ /\d/ }.map(&:to_f)
      # raise
    end
    @flashcard.update_attribute(:correct_answers, correct_answers)
  end

  def next_exam_flashcard(exam)
    @questions = exam.questions
    current_question = Flashcard.find(params[:id]).id
    flashcard_id = @questions.index(current_question) + 1

    if flashcard_id < @questions.size
      flashcard = Flashcard.find(@questions[flashcard_id])
      redirect_to custom_exam_flashcard_path(exam, flashcard)
    else
      redirect_to custom_exam_results_path(exam)
    end
  end
end
