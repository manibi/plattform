class FlashcardsController < ApplicationController
  before_action :authenticate_user!

  # Reset flashcards for this article if re-taking the quiz
  def show
    @flashcard = Flashcard.find(params[:id])
    @article = Article.find(params[:article_id])

    if @article.flashcards.first == @flashcard && current_user.right_answered_flashcards_for(@article).count == @article.flashcards.count
      Flashcard.reset_for!(current_user, @article)
    end
  end

  # Create a queue and add all the wrong answers
  # if the answer if false add the flashcard again at the top
  # else save it

  # user selects answer
  # send form
  # check answser
  # render form again with disabled fields and no submit button
  # show right answers - feedback on how he did
  # render btn to next_flashcard
  def answer
    @flashcard = Flashcard.find(params[:id])
    @article = @flashcard.article

    if set_answer
      @answers = set_answer[:answer_ids].map(&:to_i)
      @user_answer = @answers.sort == @flashcard.correct_answers.sort
    end

    @flashcard.save_answer_for!(current_user, @user_answer)

    render "flashcards/show"
  end

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
    @right_answered_flashcards = current_user.right_answered_flashcards_for(@article)

    if @article.flashcards.last != @flashcard && (!(@article.flashcards.last.in? @wrong_answered_flashcards) && !(@article.flashcards.last.in? @right_answered_flashcards))
      @next_flashcard = @article.flashcards[@article.flashcards.sort.index(@flashcard) + 1]
    else
      @next_flashcard = @wrong_answered_flashcards.sample
    end

    if @right_answered_flashcards.count == @article.flashcards.count
      redirect_to article_quiz_results_path(@article)
    else
      redirect_to article_flashcard_path(@article, @next_flashcard)
    end
  end

  private

  def set_answer
    params.require(:flashcard).permit(answer_ids: []) if params[:flashcard]
  end
end
