class Article < ApplicationRecord
  belongs_to :topic

  validates :title, presence: true, allow_blank: false
  validates :description, presence: true, allow_blank: false
  validates :topic_id, presence: true
end
