class TopicsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_and_authorize_topic, only: [:show, :edit, :update]
  before_action :tab_params, only: [:index, :show]
  before_action :count, only: [:index, :show]

  def index
  end

  def show
  end

  def new
    @topic = Topic.new
    authorize @topic
  end

  def create
    @topic = current_user.profession.topics.new(topic_params)
    authorize @topic

    if @topic.save
      redirect_to articles_path, notice: "Topic created!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @topic.update(topic_params)
      redirect_to articles_path, notice: "Topic updated!"
    else
      render :edit
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:name)
  end

  def set_and_authorize_topic
    @topic = Topic.find(params[:id])
    authorize @topic
  end

  def tab_params 
    @upcoming_articles = policy_scope(Article)
    @bookmarked_articles = current_user.bookmarked_articles
    @read_articles = current_user.read_articles
    @topics = policy_scope(Topic)
    @categories = current_user.all_categories

    @upcoming_categories = @categories.find(@upcoming_articles.map { |a| a.category_id })
    @upcoming_topics = @topics.find(@upcoming_categories.map { |c| c.topic_id })
    @bookmarked_categories = @categories.find(@bookmarked_articles.map { |a| a.category_id })
    @bookmarked_topics = @topics.find(@bookmarked_categories.map { |c| c.topic_id })
    @read_categories = @categories.find(@read_articles.map { |a| a.category_id })
    @read_topics = @topics.find(@read_categories.map { |c| c.topic_id })
  end

  def count
    @count = @topics.map { |t| @categories.map { |c| c.topic_id }.count(t.id) }
  end
end