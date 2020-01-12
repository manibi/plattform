class FlashcardsController < ApplicationController
  before_action :authenticate_user!

  # Set all answers to false if starting a new quiz
  # - if it's the first flaschard and no correct answers were given before
  def show
    @flashcard = Flashcard.find(params[:id])
    @article = Article.find(params[:article_id])
    # raise

    if @article.flashcards.first == @flashcard && current_user.wrong_answered_flashcards_for(@article).to_a.empty?
      UserFlashcard.create_all_user_flashcards_for(current_user, @article)
    end
  end

  # Create a queue and add all the wrong answers
  # if the answer if false add the flashcard again at the top
  # else save it

  # user selects answer
  # send form
  # check answser
  # render form again with disabled fields and no submit button
  # show right answers - feedback on how he did
  # render btn to next_flashcard
  def answer
    # raise
    @flashcard = Flashcard.find(params[:id])
    @article = @flashcard.article

    if set_answer
      @answers = set_answer[:answer].map(&:to_i)
      @user_answer = @answers.sort == @flashcard.correct_answers.sort
    end

    if @user_answer
      @flashcard.save_answer_for!(current_user, @user_answer)
    end

    render "flashcards/show"
  end

  def results
    @article = Article.find(params[:article_id])
    @upcoming_articles = current_user.upcoming_articles
    @all_answered_flashcards = current_user.answered_flashcards_for(@article)

    # Next article to read
    if @upcoming_articles.empty?
      @next_article = @article.topic.articles.first
    else
      @next_article = @upcoming_articles.first
    end

    render "flashcards/results"
  end

  # Return next flashcard or flashcard results
  def next_flashcard
    @article = Article.find(params[:article_id])
    @flashcard = Flashcard.find(params[:id])

    @next_flashcard = @article.flashcards[@article.flashcards.index(@flashcard) + 1]

    if current_user.wrong_answered_flashcards_for(@article).empty?
      redirect_to article_quiz_results_path(@article)
    elsif @next_flashcard &&
      current_user.wrong_answered_flashcards_for(@article).any?
      redirect_to article_flashcard_path(@article, @next_flashcard)
    else
      @next_article = current_user.wrong_answered_flashcards_for(@article).first
      redirect_to article_flashcard_path(@article, @next_article)
    end
  end

  private

  def set_answer
    params.require(:flashcard).permit(answer: []) if params[:flashcard]
  end
end
