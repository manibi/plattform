class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: [:show, :edit, :update]

  def show
    @topics = current_user.profession.topics
    @topic = @topics.find(@category.topic_id)

    @upcoming_articles = policy_scope(Article)
    @bookmarked_articles = current_user.bookmarked_articles
    @read_articles = current_user.read_articles
  end

  def new
    @category = Category.new
    @topics = current_user.profession.topics
    authorize @category
  end

  def create
    @category = Category.new(category_params)
    @topics = current_user.profession.topics
# raise
    authorize @category

    if @category.save
      redirect_to articles_path, notice: "Module created!"
    else
      render :new
    end

  end

  def edit
    @topics = current_user.profession.topics
  end

  def update
    @topics = current_user.profession.topics

    if @category.update(category_params)
      redirect_to articles_path, notice: "Module updated!"
    else
      render :edit
    end
  end

  private

  def category_params
    params.require(:category).permit(:title, :description, :topic_id)
  end

  def set_category
    @category = Category.find(params[:id])
    authorize @category
  end
end
