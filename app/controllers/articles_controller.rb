class ArticlesController < ApplicationController
  before_action :authenticate_user!

  def index
    @upcoming_articles = policy_scope(Article)
    @bookmarked_articles = current_user.bookmarked_articles
    @read_articles = current_user.read_articles
    @topics = policy_scope(Topic)

    # Author view
    @all_articles = current_user.all_articles
    @topics = current_user.profession.topics
    @categories = current_user.all_categories

    # Render views for student or author
    render current_user.student? ? 'articles/index' : 'articles/author_index'
  end

  # Set all flashcard answers to false for one article when showing it
  def show
    @article = Article.find(params[:id])
    authorize @article
    @flashcard = @article.flashcards.first
  end

  def new
    @article = Article.new
    authorize @article
    @categories = current_user.all_categories
  end

  def create
    @new_article = Article.new
    authorize @new_article
    @categories = current_user.all_categories
    chapter_params = article_params[:chapters_attributes]
    @article = Article.new(article_params)
    @article.build(chapter_params) if @article.persisted?

    # raise
    if @article.save
      redirect_to edit_article_path(@article), notice: "Article created!"
    else
      render :new
    end
  end

  def edit
    @article = Article.find(params[:id])
    authorize @article
    @categories = current_user.all_categories
  end

  def update
    @article = Article.find(params[:id])
    authorize @article

    if @article.update(article_params)
      redirect_to @article, notice: "Article updated!"
    else
      render :edit
    end
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

  private

  def article_params
    params.require(:article).permit(:category_id,
                                    :image,
                                    :title,
                                    :description,
                                    chapters_attributes: Chapter.attribute_names.map(&:to_sym).push(:_destroy))
  end
end
