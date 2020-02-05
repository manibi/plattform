class CustomExam < ApplicationRecord
  belongs_to :user
  has_many   :custom_exam_answers, dependent: :destroy

  serialize :questions, Array

  validates :user_id, presence: true

  def submit!
    self.update(submitted: true)
  end

  def submit_custom_exam?
    if self.custom_exam_answers.any?
      self.custom_exam_answers.last.flashcard.id == self.questions.last
    end
  end

  def correct_answered_questions
    self.custom_exam_answers.where(correct: true).count
  end

  def unanswered_questions
    self.custom_exam_answers.where(answered: false).count
  end

  def all_questions
    Flashcard.find(self.questions)
  end
end
