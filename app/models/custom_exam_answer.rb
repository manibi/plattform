class CustomExamAnswer < ApplicationRecord
  belongs_to :flashcard
  belongs_to :custom_exam

  serialize :user_answers, Array

  validates :flashcard_id, presence: true
  validates :custom_exam_id, presence: true
end
