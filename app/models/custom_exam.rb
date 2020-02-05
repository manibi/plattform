class CustomExam < ApplicationRecord
  belongs_to :user
  has_many   :custom_exam_answers, dependent: :destroy

  serialize :questions, Array

  validates :user_id, presence: true

  def submit_custom_exam?
    if self.custom_exam_answers.any?
      self.custom_exam_answers.last.flashcard.id == self.questions.last
    end
  end
end
