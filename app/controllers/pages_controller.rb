class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:landing_page, :company_dashboard]

  def search
    authorize current_user, :show?
    if params[:query]
      @results = PgSearch.multisearch(params[:query])
      @topics = @results.where(searchable_type: "Topic")
      @categories = @results.where(searchable_type: "Category")
      @articles = @results.where(searchable_type: "Article")

      respond_to do |format|
        format.html {}
        format.json {}
      end
    end
  end

  def landing_page
    if company_signed_in?
      redirect_to company_dashboard_path
    elsif user_signed_in?
      if current_user.admin?
        redirect_to admin_dashboard_path
      elsif current_user.author?
        redirect_to author_dashboard_path
      else
        redirect_to dashboard_path
      end
    end
  end

  def dashboard
    authorize current_user, :show?
    @read_user_articles = UserArticle.where(user: current_user, read: true)
    read_article_ids = @read_user_articles.map { |user_article| user_article.article_id  }
    @not_read_articles = Article.where.not(id: read_article_ids)
    @not_read_category = policy_scope(Category).find(@not_read_articles.map{ |a| a.category_id}.sort.first)

    @upcoming_articles = policy_scope(Article)
    # if the user didn't ready any article set current article to first one
    if @read_user_articles.empty? || @not_read_articles.empty?
      @current_article = current_user.profession.topics.first.categories.first.articles.first
    else
      @current_article = @not_read_articles.select { |na| na.category_id == @not_read_articles.map { |a| a.category_id }.sort.first }.first
    end
    @articles = policy_scope(Article)
    @current_topic = @current_article.category.topic
    @current_category = @current_article.category
    # @current_articles = @current_category.find(@articles.map{ |a| a.category_id })
    @category_index = @current_category.id
    @category_index = @current_topic.categories.find(@current_article.category_id)
    @article_index = @category_index.article_ids.find_index(@current_article)
    # raise
  end

  def author_dashboard
    authorize current_user
  end

  def exam_info
    @exam = CustomExam.find(params[:custom_exam_id])
    @first_flashcard = Flashcard.find(@exam.questions.first)
    authorize current_user, :show?
  end
end
