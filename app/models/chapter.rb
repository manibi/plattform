class Chapter < ApplicationRecord
  belongs_to :article, optional: true

  validates :title, presence: true, allow_blank: false
  validates :content, presence: true, allow_blank: false
  validates :article_id, presence: true
end
