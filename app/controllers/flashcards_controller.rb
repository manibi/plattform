class FlashcardsController < ApplicationController
  before_action :authenticate_user!

  def new
    @flashcard = Flashcard.new
    @flashcard.answers.build
  end

  def show
    @flashcard = Flashcard.find(params[:id])
    @article = Article.find(params[:article_id])

    @article.read_for!(current_user) unless @article.read_for?(current_user)

    # Reset flashcards for this article if re-taking the quiz
    if @article.flashcards.sort.first == @flashcard && current_user.correct_answered_flashcards_for(@article).count == @article.flashcards.count
      Flashcard.reset_for!(current_user, @article)
    end
  end

  def create
    @article_id = new_flashcard_params.delete("article").to_i
    @article = Article.find(@article_id)
    flashcard_params = new_flashcard_params.except(:article)
    # flashcard_params[:correct_answers] = flashcard_params[:correct_answers].split
    @flashcard = @article.flashcards.build(flashcard_params)

    if @flashcard.save
      flash[:notice] = "Flashcard created"
      redirect_to edit_flashcard_path(@flashcard)
    else
      render :new
    end
  end

  def edit
    @flashcard = Flashcard.find(params[:id])
  end

  def update
    @flashcard = Flashcard.find(params[:id])
    flashcard_params = new_flashcard_params
    # raise
    flashcard_params[:article] = Article.find(flashcard_params[:article])
    # debugger
    # flashcard_params[:correct_answers] = flashcard_params[:correct_answers].split

    if @flashcard.update(flashcard_params)
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
    @article = @flashcard.article
    @correct_answers = @flashcard.correct_answers.sort.map(&:to_i)

    if set_multiple_choice_answer
      @answers = set_multiple_choice_answer[:answer_ids].map(&:to_i)
      @user_answer = @answers.sort ==  @correct_answers
    else
      @user_answer = false
    end

    @flashcard.save_answer_for!(current_user, @user_answer)
    # raise
    render "flashcards/show"
  end

  def answer_correct_order
    @flashcard = Flashcard.find(params[:id])
    @article = @flashcard.article

    # Check answers
    @answers = set_correct_order_answer.to_h.keys.map(&:to_i)
    @user_answer = @flashcard.correct_answers == @answers

    # Save flashcard
    @flashcard.save_answer_for!(current_user, @user_answer)

    # Show results
    render "flashcards/show"
  end

  def answer_match
    @flashcard = Flashcard.find(params[:id])
    @article = @flashcard.article

    # Check answers
    @answers = set_correct_order_answer.to_h.keys.map(&:to_i)
    @user_answer = @flashcard.correct_answers == @answers

    # Save flashcard
    @flashcard.save_answer_for!(current_user, @user_answer)

    # Show results
    render "flashcards/show"
  end

  def input_numbers
    @flashcard = Flashcard.find(params[:id])
    @article = @flashcard.article

    # Check answers
    @answers = set_correct_order_answer.to_h.values.map(&:to_i)
    @user_answer = @flashcard.correct_answers == @answers

    # Save flashcard
    @flashcard.save_answer_for!(current_user, @user_answer)

    # Show results
    render "flashcards/show"
  end

  # def result
  #   @flashcard = Flashcard.find(params[:id])
  #   @article = @flashcard.article
  # end

  def results
    @article = Article.find(params[:article_id])
    @upcoming_articles = current_user.upcoming_articles
    @all_answered_flashcards = current_user.answered_flashcards_for(@article)

    # Next article to read
    if @upcoming_articles.empty?
      @next_article = @article.topic.articles.first
    else
      @next_article = @upcoming_articles.first
    end

    render "flashcards/results"
  end

  # Return next flashcard or flashcard results
  def next_flashcard
    @flashcard = Flashcard.find(params[:id])
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
    params.require(:flashcard).permit(:article, :flashcard_type, :content, correct_answers: [], answers_attributes: Answer.attribute_names.map(&:to_sym).push(:_destroy))
  end
end
