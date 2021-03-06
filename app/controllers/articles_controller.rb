class ArticlesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article, except: [:index, :new, :create]
  before_action :set_all, only: [:show, :read_next]

  def index
    authorize Article.new
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
    @flashcards_queue = FlashcardQueue.init_flashcards_queue(current_user, @article)
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
    # chapter_params = article_params[:chapters_attributes]
    @article = Article.new(article_params)
    if @article.save
      # raise
      @article.sign_article!(current_user)
      redirect_to edit_article_path(@article), notice: "Article created!"
    else
      render :new
    end
  end

  def edit
    @article.chapters.build([
      { title: "Erläuterung" },
      { title: "Praxisbeispiel aus der Wirtschaft" },
      { title: "Verwandte Themen" },
      ]) if @article.chapters.empty?
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

  def destroy
    @article.destroy
    redirect_back(fallback_location: admin_dashboard_path)
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
    redirect_back(fallback_location: @article)
  end

  def unpublish
    @article.unpublish!
    redirect_back(fallback_location: @article)
  end

  def flashcards
  end

  def read_next
    if @upcoming_articles.empty?
      @next_article = current_user.profession
                                  .topics.first
                                  .categories.first
                                  .articles.first
    elsif (@upcoming_articles & @category.articles).without(@article) != [] && @next_article = (@upcoming_articles & @category.articles).select{|a| a.id > @article.id} != []
      @next_article = (@upcoming_articles & @category.articles).select{|a| a.id > @article.id}.first
    elsif @topic.categories.select { |c| c.id > @category.id }.select { |c| c.articles & @upcoming_articles } != [] && @topic.categories.select { |c| c.id > @category.id }.select { |c| c.articles & @upcoming_articles }.first.articles.select { |a| @upcoming_articles.include?(a) } != []
      @next_article = @topic.categories.select { |c| c.id > @category.id }.select { |c| c.articles & @upcoming_articles }.first.articles.select { |a| @upcoming_articles.include?(a) }.first
    elsif @topics.select { |t| t.id > @topic.id }.select { |t| t.categories.each { |c| c.articles & @upcoming_articles } } != [] && @topics.select { |t| t.id > @topic.id }.select { |t| t.categories.each { |c| c.articles & @upcoming_articles } }.first.categories.select { |c| c.articles & @upcoming_articles } != [] && @topics.select { |t| t.id > @topic.id }.select { |t| t.categories.each { |c| c.articles & @upcoming_articles } }.first.categories.select { |c| c.articles & @upcoming_articles }.first.articles != [] && @topics.select { |t| t.id > @topic.id }.select { |t| t.categories.each { |c| c.articles & @upcoming_articles } }.first.categories.select { |c| c.articles & @upcoming_articles }.first.articles.select { |a| @upcoming_articles.include?(a) } != []
      @next_article = @topics.select { |t| t.id > @topic.id }.select { |t| t.categories.each { |c| c.articles & @upcoming_articles } }.first.categories.select { |c| c.articles & @upcoming_articles }.first.articles.select { |a| @upcoming_articles.include?(a) }.first
    elsif @topics.select { |t| t.id < @topic.id }.select { |t| t.categories.each { |c| c.articles & @upcoming_articles } } != [] && @topics.select { |t| t.id < @topic.id }.select { |t| t.categories.each { |c| c.articles & @upcoming_articles } }.first.categories.select { |c| c.articles & @upcoming_articles } != [] && @topics.select { |t| t.id < @topic.id }.select { |t| t.categories.each { |c| c.articles & @upcoming_articles } }.first.categories.select { |c| c.articles & @upcoming_articles }.first.articles !=[] && @topics.select { |t| t.id < @topic.id }.select { |t| t.categories.each { |c| c.articles & @upcoming_articles } }.first.categories.select { |c| c.articles & @upcoming_articles }.first.articles.select { |a| @upcoming_articles.include?(a) } != []
      @next_article = @topics.select { |t| t.id < @topic.id }.select { |t| t.categories.each { |c| c.articles & @upcoming_articles } }.first.categories.select { |c| c.articles & @upcoming_articles }.first.articles.select { |a| @upcoming_articles.include?(a) }.first
    else
      @next_article = @upcoming_articles.first
    end

    @article.read_for!(current_user)
    redirect_to @next_article
  end

  private

  def set_all
    if current_user.student? || current_user.author?
    # @flashcard = @article.flashcards.published.first
    @categories = current_user.all_categories
    @category = @categories.find(@article.category_id)
    @topics = current_user.profession.topics
    @topic = @topics.find(@category.topic_id)
    @articles = current_user.all_articles.published
    @read_articles = current_user.read_articles.published
    @bookmarked_articles = current_user.bookmarked_articles.published
    @upcoming_articles = @articles - @read_articles
    end
  end

  def set_article
    @article = Article.find(params[:id])
    authorize @article
  end

  def article_params
    params.require(:article).permit(:category_id,
                                    :image,
                                    :title,
                                    :description,
                                    chapters_attributes: [:id, :_destroy, :title, :content])
  end
end