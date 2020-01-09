class FlashcardsController < ApplicationController
  before_action :authenticate_user!

  # Set all answers to false if starting a new quiz
  # - if it is the first flaschard and no correct answers were given
  def show
    @flashcard = Flashcard.find(params[:id])
    @article = Article.find(params[:article_id])

    if @article.flashcards.first == @flashcard && current_user.wrong_answered_flashcards_for(@article).to_a.empty?
      create_user_flashcards_for!(current_user, @article)
    end
  end

  # Create a queue and add all the wrong answers
  # if the answer if false add the flashcard again at the top
  # else save it
  def answer
    @flashcard = Flashcard.find(params[:id])
    @article = @flashcard.article
    @article_flashcards = @article.flashcards
    @user_flashcards_queue = current_user.wrong_answered_flashcards_for(@article).to_a
    user_answer = set_answer["answer"] == "true"

    if user_answer
      @flashcard.save_answer_for!(current_user, user_answer)
      @user_flashcards_queue = current_user.wrong_answered_flashcards_for(@article).to_a
    elsif @user_flashcards_queue.any?
      wrong_answered_flashcard = @user_flashcards_queue.shift
      @user_flashcards_queue.push(wrong_answered_flashcard)
    end

    redirect_to next_flashcard(@user_flashcards_queue)
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

  private

  def set_answer
    params.permit(:answer)
  end

  # Return next flashcard in queue or flashcard results
  def next_flashcard(queue)
    if queue.any?
      article_flashcard_path(@article, queue.first)
    else
      article_quiz_results_path(@article)
    end

    # old
    # if @article_flashcards.last.id != params[:id].to_i &&
    #   article_flashcard_path(@article, @article_flashcards[@article_flashcards.index(@flashcard) + 1])
    #   else
    #       article_quiz_results_path(@article)
    #   # article_flashcard_path(@article, @article.flashcards.first)
    # end
  end
end
