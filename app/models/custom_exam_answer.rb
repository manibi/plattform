class CustomExamAnswer < ApplicationRecord
  belongs_to :flashcard
  belongs_to :custom_exam

  validates :flashcard_id, presence: true
  validates :custom_exam_id, presence: true
end
