class ArticlesController < ApplicationController
  before_action :authenticate_user!

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def read
    @article = Article.find(params[:id])
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
    @article.bookmark_for!(current_user)
    redirect_to @article
  end

  def unbookmark
    @article = Article.find(params[:id])
    @article.unbookmark_for!(current_user)
    redirect_to @article
  end
end
