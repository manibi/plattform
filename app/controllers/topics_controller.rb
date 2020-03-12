class TopicsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_and_authorize_topic, only: [:show, :edit, :update]
  before_action :tab_params_index, only: [:index]
  before_action :tab_params_show, only: [:show]

  def index
  end

  def show
  end

  def new
    @topic = Topic.new
    authorize @topic
    @professions = Profession.all
  end

  def create
    @topic = current_user.profession.topics.new(topic_params)
    authorize @topic

    if @topic.save
      flash[:notice] = "Topic created!"
      redirect_to admin_dashboard_path, notice: "Topic created!"
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

  def tab_params_index
    @topics = policy_scope(Topic)
    @categories = current_user.all_categories
    @articles = current_user.all_articles.published

    @read_articles = current_user.read_articles.published
    @read_categories = @categories.find(@read_articles.map { |a| a.category_id } )
    @read_topics = @topics.select { |t|  @read_categories.map { |c| c.topic_id }.include?(t.id) }
    # @read_topics = @topics.find(@read_categories.map { |c| c.topic_id })

    @upcoming_articles = @articles - @read_articles
    @upcoming_categories = @categories.find(@upcoming_articles.map { |a| a.category_id })
    @upcoming_topics = @topics.select { |t| @upcoming_categories.map { |c| c.topic_id }.include?(t.id) }
    # upcoming_topics = topics.select {|t| t.categories.each {|c| c.articles.each { |a| @read_topics.exclude?(a) } } }

    @bookmarked_articles = current_user.bookmarked_articles.published
    @bookmarked_categories = @categories.find(@bookmarked_articles.map { |a| a.category_id })
    @bookmarked_topics = @topics.select { |t| @bookmarked_categories.map { |c| c.topic_id }.include?(t.id) }
    # @bookmarked_topics = @topics.select {|t| t.categories.each {|c| c.articles.each { |a| current_user.bookmarked_articles.include?(a) } } }
  end

  def tab_params_show
    @articles = current_user.all_articles.published
    @read_articles = current_user.read_articles.published
    @bookmarked_articles = current_user.bookmarked_articles.published
    @upcoming_articles = @articles - @read_articles
    @topics = policy_scope(Topic)
    @categories = current_user.all_categories
    @topic = Topic.find(params[:id])
    @topic_categories = @categories.select { |c| c.topic_id == @topic.id }

    @upcoming_categories = @topic_categories.select{ |c| @upcoming_articles.map { |a| a.category_id }.include?(c.id)}
    @bookmarked_categories = @topic_categories.select{ |c| @bookmarked_articles.map { |a| a.category_id }.include?(c.id)}
    @read_categories = @topic_categories.select{ |c| @read_articles.map { |a| a.category_id }.include?(c.id)}
  end
end