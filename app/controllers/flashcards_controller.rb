class FlashcardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_all, only: [:results]

  def index
    @articles = policy_scope(Flashcard)
  end

  def new
    @flashcard = Flashcard.new
    authorize @flashcard
    @articles = current_user.all_articles
    # @flashcard.answers.build
  end

  def show
    @flashcard = Flashcard.find(params[:id])
    authorize @flashcard
    @article = @flashcard.article
    @exam_flashcard = request.path.include? "exams"

    if @flashcard.flashcard_type == "match_answers"
      @dragabble_answers  = Answer.find(@flashcard.correct_answers)
      @static_answers     = Answer.find(@flashcard.answers.pluck(:id) - @flashcard.correct_answers)
    end

    if @flashcard.flashcard_type == "table_quiz"
    @table_headings = @flashcard.answers.pluck(:content).select { |v| v =~ /\D/ }
    @table_answer_rows =  @flashcard.correct_answers.each_slice(4).to_a
    end

    if @exam_flashcard
      @exam = CustomExam.find(params[:custom_exam_id])
      @questions = @exam.all_questions
      @user_answers = @flashcard.user_answers_for(@exam)
    else
       @article.read_for!(current_user) unless @article.read_for?(current_user)

      # Reset flashcards for this article if re-taking the quiz
      if @article.flashcards.published.sort.first == @flashcard && current_user.correct_answered_flashcards_for(@article).count == @article.flashcards.published.count
        Flashcard.reset_for!(current_user, @article)
      end
    end
  end

  def create
    @new_flashcard = Flashcard.new
    authorize @new_flashcard

    @article_id = new_flashcard_params.delete("article").to_i
    @article = Article.find(@article_id)
    @articles = current_user.all_articles
    flashcard_params = new_flashcard_params.except(:article)
    @flashcard = @article.flashcards.build(flashcard_params)

    if @flashcard.save
      @flashcard.sign_flashcard!(current_user)
      set_correct_answers if %w[match_answers soll_ist table_quiz].include? @flashcard.flashcard_type

      redirect_to edit_flashcard_path(@flashcard), notice: "Flashcard created!"
    else
      render :new
    end
  end

  def edit
    @flashcard = Flashcard.find(params[:id])
    @articles = current_user.all_articles

    authorize @flashcard
  end

  def update
    @flashcard = Flashcard.find(params[:id])
    authorize @flashcard

    flashcard_params = new_flashcard_params
    flashcard_params[:article] = Article.find(flashcard_params[:article])

    if @flashcard.flashcard_type == "correct_order"
      flashcard_params[:correct_answers] = flashcard_params[:correct_answers].map { |order| @flashcard.answers[order.to_i - 1].id }
    end

    if @flashcard.update(flashcard_params)
      @flashcard.sign_edit_flashcard!(current_user)
      set_correct_answers if %w[match_answers soll_ist table_quiz].include? @flashcard.flashcard_type

      redirect_to article_flashcard_path(@flashcard.article, @flashcard), notice: "Flashcard updated!"
    else
      render :edit
    end
  end

  def publish
    @flashcard = Flashcard.find(params[:id])
    authorize @flashcard
    @flashcard.publish!
    redirect_back(fallback_location: @flashcard)
  end

  def unpublish
    @flashcard = Flashcard.find(params[:id])
    authorize @flashcard
    @flashcard.unpublish!
    redirect_back(fallback_location: @flashcard)
  end

  # Bookmark exam flashcard
  def bookmark
    @flashcard = Flashcard.find(params[:id])
    authorize @flashcard, :show?

    if request.path.include? "exams"
      @exam = CustomExam.find(params[:custom_exam_id])
      @flashcard.bookmark_for!(@exam)
      redirect_to custom_exam_flashcard_path(@exam, @flashcard)
    end
  end

  def unbookmark
    @flashcard = Flashcard.find(params[:id])
    authorize @flashcard, :show?

    if request.path.include? "exams"
      @exam = CustomExam.find(params[:custom_exam_id])
      @flashcard.unbookmark_for!(@exam)
      redirect_to custom_exam_flashcard_path(@exam, @flashcard)
    end
  end

  # user selects answer
  # send form
  # check answser
  # render form again with disabled fields and no submit button
  # show right answers - feedback on how he did
  # render btn to next_flashcard
  def answer_multiple_choice
    @flashcard = Flashcard.find(params[:id])
    authorize @flashcard, :show?

    @article = @flashcard.article
    @correct_answers = @flashcard.correct_answers.sort.map(&:to_i)

    if set_multiple_choice_answer
      @answers = set_multiple_choice_answer[:answer_ids].map(&:to_i)
      @is_answer_correct = @answers.sort ==  @correct_answers
    else
      @is_answer_correct = false
    end

    if request.path.include? "exams"
      @exam = CustomExam.find(params[:custom_exam_id])
      question_answered = !!set_multiple_choice_answer
      # save exam answer
      @flashcard.save_exam_answer_for!(@exam, question_answered, @answers, @is_answer_correct)
      # redirect to next flashcard
      next_exam_flashcard(@exam)
    else
      @flashcard.save_answer_for!(current_user, @is_answer_correct)
      render "flashcards/show"
    end
  end

  def answer_correct_order
    @flashcard = Flashcard.find(params[:id])
    authorize @flashcard, :show?
    @article = @flashcard.article

    if @flashcard.flashcard_type == 'match_answers'
      @dragabble_answers  = Answer.find(@flashcard.correct_answers)
      @static_answers     = Answer.find(@flashcard.answers.pluck(:id) - @flashcard.correct_answers)
    end

    # Check answers
    @answers = set_correct_order_answer.to_h.keys.map(&:to_i)
    @is_answer_correct = @flashcard.correct_answers == @answers

    if request.path.include? "exams"
      @exam = CustomExam.find(params[:custom_exam_id])
      # save exam answer, question will always count as answered
      @flashcard.save_exam_answer_for!(@exam, true, @answers, @is_answer_correct)
      # redirect to next flashcard
      next_exam_flashcard(@exam)
    else
      @flashcard.save_answer_for!(current_user, @is_answer_correct)
      render "flashcards/show"
    end
  end

  def soll_ist
    @flashcard = Flashcard.find(params[:id])
    authorize @flashcard, :show?
    @article = @flashcard.article

    # Check answers
    @answers = set_correct_order_answer.to_h.values.map(&:to_f)
    @is_answer_correct = @flashcard.correct_answers == @answers
    @table_headings = @flashcard.answers.pluck(:content).select { |v| v =~ /\D/ }
    @table_answer_rows =  @flashcard.correct_answers.each_slice(4).to_a

    if request.path.include? "exams"
      @exam = CustomExam.find(params[:custom_exam_id])
      question_answered = @answers.sum != 0
      # save exam answer
      @flashcard.save_exam_answer_for!(@exam, question_answered, @answers, @is_answer_correct)
      # redirect to next flashcard
      next_exam_flashcard(@exam)
    else
      @flashcard.save_answer_for!(current_user, @is_answer_correct)
    # raise

      render "flashcards/show"
    end
  end

  def results
    @article = Article.find(params[:article_id])
    authorize @article, :show?

    @upcoming_articles = policy_scope(Article)
    @all_answered_flashcards = current_user.answered_flashcards_for(@article)
    @tries = current_user.user_flashcards_for(@article).pluck(:tries).sum

    # Next article to read
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

    @categories = current_user.all_categories
    @category = @categories.find(@article.category_id)
    @topics = current_user.profession.topics
    @topic = @topics.find(@category.topic_id)

    render "flashcards/results"
  end

  # ! Refactor with Queue class?
  # Return next article flashcard or flashcard results
  def next_flashcard
    @flashcard = Flashcard.find(params[:id])
    authorize @flashcard, :show?

    @article = @flashcard.article
    @wrong_answered_flashcards = current_user.wrong_answered_flashcards_for(@article).published
    @correct_answered_flashcards = current_user.correct_answered_flashcards_for(@article).published
    flashcards_to_do = @article.flashcards.published.sort

    if flashcards_to_do.last != @flashcard && !current_user.answered?(flashcards_to_do.last)
      @next_flashcard = flashcards_to_do[flashcards_to_do.index(@flashcard) + 1]
    else
      @next_flashcard = @wrong_answered_flashcards.sample
    end

    if @correct_answered_flashcards.count == flashcards_to_do.count
      redirect_to article_quiz_results_path(@article)
    else
      redirect_to article_flashcard_path(@article, @next_flashcard)
    end
  end

  private

  def set_all
    @article = Article.find(params[:article_id])
    @flashcard = @article.flashcards.first
    @categories = current_user.all_categories
    @category = @categories.find(@article.category_id)
    @topics = current_user.profession.topics
    @topic = @topics.find(@category.topic_id)
    @upcoming_articles = policy_scope(Article)
  end

  def set_multiple_choice_answer
    params.require(:flashcard).permit(answer_ids: []) if params[:flashcard]
  end

  def set_correct_order_answer
    @flashcard = Flashcard.find(params[:id])
    params.require(:flashcard).require(:answer).permit! if params[:flashcard]
  end

  def new_flashcard_params
    params.require(:flashcard).permit(:article, :image, :flashcard_type, :content, correct_answers: [], answers_attributes: Answer.attribute_names.map(&:to_sym).push(:_destroy))
  end

  def set_correct_answers
    if @flashcard.flashcard_type == "match_answers"
      correct_answers = @flashcard.answers.pluck(:id).select.with_index { |id, i| id if i.odd? }
    elsif @flashcard.flashcard_type == "soll_ist"
      correct_answers = @flashcard.answers.pluck(:content).map(&:to_i)
    else
      correct_answers = @flashcard.answers.pluck(:content).select { |v| v =~ /\d/ }.map(&:to_f)
    end
    @flashcard.update_attribute(:correct_answers, correct_answers)
  end

  def next_exam_flashcard(exam)
    @questions = exam.all_questions
    current_question = Flashcard.find(params[:id])
    flashcard_idx = @questions.index(current_question) + 1

    if flashcard_idx < @questions.size
      flashcard = @questions[flashcard_idx]
      redirect_to custom_exam_flashcard_path(exam, flashcard)
    else
      redirect_to custom_exam_submit_exam_path(exam)
    end
  end
end
