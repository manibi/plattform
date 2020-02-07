class CustomExam < ApplicationRecord
  belongs_to :user
  has_many   :custom_exam_answers, dependent: :destroy

  serialize :questions, Array

  validates :user_id, presence: true
  validates_length_of :questions, minimum: 1

  def submit!
    self.update(submitted: true)
  end

  def correct_answered_questions
    self.custom_exam_answers.where(correct: true).count
  end

  def answered_questions
    self.custom_exam_answers.where(answered: true).count
  end

  def unanswered_questions
    self.custom_exam_answers.where(answered: false).count
  end

  def all_questions
    Flashcard.find(self.questions)
  end

  # Return question answer
  def answer_for(question)
    question.custom_exam_answers.find_by(custom_exam_id: self)
  end

  # Return all flashcards from selected articles(array of articles ids)
  def self.exam_questions_from(articles)
    Flashcard.joins(:article).where(article: articles)
  end
end
