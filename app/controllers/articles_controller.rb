class ArticlesController < ApplicationController
  before_action :authenticate_user!

  def index
    @upcoming_articles = policy_scope(Article)
    @bookmarked_articles = current_user.bookmarked_articles
    @read_articles = current_user.read_articles

    # Author view
    @all_articles = current_user.all_articles
    @topics = current_user.profession.topics

    # Render views for student or author
    render current_user.student? ? 'articles/index' : 'articles/author_index'
  end

  # Set all flashcard answers to false for one article when showing it
  def show
    @article = Article.find(params[:id])
    authorize @article
    @flashcard = @article.flashcards.first
  end

  def read
    @article = Article.find(params[:id])
    authorize @article, :show?

    @article.read_for!(current_user)
    redirect_to @article
  end

  def unread
    @article = Article.find(params[:id])
    @article.unread_for!(current_user)
    redirect_to @article
  end

  def bookmark
    @article = Article.find(params[:id])
    authorize @article, :show?

    @article.bookmark_for!(current_user)
    @article.read_for!(current_user) unless @article.read_for?(current_user)

    redirect_to @article
  end

  def unbookmark
    @article = Article.find(params[:id])
    authorize @article, :show?

    @article.unbookmark_for!(current_user)
    redirect_to @article
  end
end
