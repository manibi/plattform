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
    # @article = UserFlashcard.last.article
    # @flashcard = @article.flashcards.first
    # @flashcards_played = UserFlashcard.where(article: @article)
    # @correct_answers = UserFlashcard.where(article: @article, correct: true)
    # @upcoming_articles = current_user.upcoming_articles
    # @flashcards_percentage = ((@correct_answers.count.to_f / @flashcards_played.count) * 100).to_i

    # if @upcoming_articles.empty?
    #   @next_article = @article.topic.articles.first
    # else
    #   @next_article = @upcoming_articles.first
    # end

    render "flashcards/results"
  end

  private

  def set_answer
    params.permit(:answer)
  end

  def next_flashcard
    if @article_flashcards.last.id != params[:id].to_i
      article_flashcard_path(@article, @article_flashcards[@article_flashcards.index(@flashcard) + 1])
      else
      flashcards_results_path
    end
  end
end
