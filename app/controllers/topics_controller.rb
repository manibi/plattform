class TopicsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_and_authorize_topic, only: [:show, :edit, :update]

  def index
    @topics = policy_scope(Topic)
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
      flash[:notice] = "Topic created!"
      redirect_to articles_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @topic.update(topic_params)
      flash[:notice] = "Topic updated!"
      redirect_to articles_path
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
end