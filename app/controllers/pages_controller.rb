class PagesController < ApplicationController
  before_action :authenticate_user!, except: [
    :landing_page,
    :mozubi,
    :azubis,
    :unternehmen,
    :datenschutz,
    :agbs,
    :impressum,
    :hilfspaket,
    :company_dashboard,
    :temporary_user_info
  ]
  before_action :authenticate_company!, only: :company_dashboard

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

  def mozubi
  end

  def azubis
  end

  def unternehmen
  end

  def datenschutz
  end

  def agbs
  end

  def impressum
  end

  def hilfspaket
  end

  # TODO! REFACTOR
  def dashboard
    authorize current_user, :show?
    @read_user_articles = UserArticle.where(user: current_user, read: true)
    read_article_ids = @read_user_articles.map { |user_article| user_article.article_id  }
    # @not_read_articles = Article.where.not(id: read_article_ids)
    # @not_read_category = policy_scope(Category).find(@not_read_articles.map{ |a| a.category_id}.sort.first)

    @articles = current_user.all_articles.published.includes([:category])
    @read_articles = current_user.read_articles.published
    @bookmarked_articles = current_user.bookmarked_articles.published
    @upcoming_articles = @articles - @read_articles
    # if the user didn't ready any article set current article to first one
    # if @current_article
    if @read_user_articles.empty? || @upcoming_articles.empty?
      @current_article = current_user.profession.topics.first.categories.first.articles.first
    else
      @current_article = @upcoming_articles.select { |a| a.category_id }.sort.first
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

  def admin_dashboard
    authorize current_user
    @admins = UserCredential.admin.includes([:profession])
    @temp_students = TemporaryUserCredential.all.includes([:profession])
    @students = UserCredential.student.includes([:profession, :company])
    @authors = UserCredential.author.includes([:profession])

    respond_to do |format|
      format.xlsx {
        response.headers[
          'Content-Disposition'
        ] = "attachment; filename='corona-students.xlsx'"

        render xlsx: 'admin_dashboard',filename: "corona-students.xlsx"
      }
      format.html { render :admin_dashboard }
    end
  end

    def admin_topics
    authorize current_user
  end

  def admin_categories
    authorize current_user
  end

  def admin_professions
    authorize current_user
  end

  def exam_info
    @exam = CustomExam.find(params[:custom_exam_id])
    @first_flashcard = @exam.all_questions.first
    authorize current_user, :show?
  end

  def temporay_user_info
  end
end
