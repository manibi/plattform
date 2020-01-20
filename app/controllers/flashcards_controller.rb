class FlashcardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @flashcard = Flashcard.find(params[:id])
    @article = Article.find(params[:article_id])

    @article.read_for!(current_user) unless @article.read_for?(current_user)

    # Reset flashcards for this article if re-taking the quiz
    if @article.flashcards.sort.first == @flashcard && current_user.correct_answered_flashcards_for(@article).count == @article.flashcards.count
      Flashcard.reset_for!(current_user, @article)
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

    if set_multiple_choice_answer
      @answers = set_multiple_choice_answer[:answer_ids].map(&:to_i)
      @user_answer = @answers.sort == @flashcard.correct_answers.sort
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
    # raise

  end

  def set_correct_order_answer
    @flashcard = Flashcard.find(params[:id])
    params.require(:flashcard).require(:answer).permit! if params[:flashcard]
  end
end
