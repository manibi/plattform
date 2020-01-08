class FlashcardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @flashcard = Flashcard.find(params[:id])
    @article = Article.find(params[:article_id])
  end

  def answer
    @flashcard = Flashcard.find(params[:id])
    @article = @flashcard.article
    @article_flashcards = @article.flashcards
    user_answer = set_answer["answer"] == "true"

    @flashcard.save_answer_for!(current_user, user_answer)
    redirect_to next_flashcard
  end

  def results
    @article = Article.find(params[:article_id])
    @upcoming_articles = current_user.upcoming_articles
    @all_answered_flashcards = current_user.answered_flashcards_for(@article)
    @correct_answered_flashcards = current_user.right_answered_flashcards_for(@article)
    @wrong_answered_flashcards = current_user.wrong_answered_flashcards_for(@article)

    # Quiz percentage - not really necessary
    if @correct_answered_flashcards.empty?
      @flashcards_percentage = 0
    else
    @flashcards_percentage = ((@correct_answered_flashcards.count.to_f / @all_answered_flashcards.count) * 100).to_i
    end

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

  # TODO: refactor to loop until all flashcards are answered correct
  def next_flashcard
    @article = Article.find(params[:article_id])
    @wrong_answered_flashcards = current_user.wrong_answered_flashcards_for(@article)
    @all_article_flashcards = @article.flashcards.count
    @correct_answered_flashcards = current_user.right_answered_flashcards_for(@article)

    # if @correct_answered_flashcards.count == @article.flashcards.size
    #   article_quiz_results_path(@article)
    # elsif @wrong_answered_flashcards.any?
    #   article_flashcard_path(@article, @wrong_answered_flashcards.first)
    # else
    #   article_flashcard_path(@article, @article.flashcards.first)
    # end
    # debugger

    # if @all_article_flashcards.count != @correct_answered_flashcards.count
    #   article_flashcard_path(@article, @article.next_flashcard)
    # else
    #   article_quiz_results_path(@article)
    # end

    if @article_flashcards.last.id != params[:id].to_i
      article_flashcard_path(@article, @article_flashcards[@article_flashcards.index(@flashcard) + 1])
    else
        article_quiz_results_path(@article)
    end
  end
end
