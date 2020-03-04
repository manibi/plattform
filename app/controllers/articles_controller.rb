class ArticlesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article, except: [:index, :new, :create]

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

  def show
    @flashcard = @article.flashcards.first
    @categories = current_user.all_categories
    @category = @categories.find(@article.category_id)
    @topics = current_user.profession.topics
    @topic = @topics.find(@category.topic_id)
  end

  def new
    @article = Article.new
    # @article.chapters.build(title: "Erläuterung")
    # @article.chapters.build(title: "Praxisbeispiel")
    # @article.chapters.build(title: "Verwandte Themen")
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

    if @article.save
      @article.sign_article!(current_user)
      redirect_to edit_article_path(@article), notice: "Article created!"
    else
      render :new
    end
  end

  def edit
    @categories = current_user.all_categories
  end

  def update
    if @article.update(article_params)
      @article.sign_edit_article!(current_user)
      redirect_to @article, notice: "Article updated!"
    else
      render :edit
    end
  end

  def read
    @article.read_for!(current_user)
    redirect_to @article
  end

  def unread
    @article.unread_for!(current_user)
    redirect_to @article
  end

  def bookmark
    @article.bookmark_for!(current_user)
    @article.read_for!(current_user) unless @article.read_for?(current_user)

    redirect_to @article
  end

  def unbookmark
    @article.unbookmark_for!(current_user)
    redirect_to @article
  end

  def publish
    @article.publish!
    redirect_to @article
  end

  def unpublish
    @article.unpublish!
    redirect_to @article
  end

  def flashcards
  end

  private

  def set_article
    @article = Article.find(params[:id])
    authorize @article
  end

  def article_params
    params.require(:article).permit(:category_id,
                                    :image,
                                    :title,
                                    :description,
                                    chapters_attributes: Chapter.attribute_names.map(&:to_sym).push(:_destroy))
  end
end
