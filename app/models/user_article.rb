class UserArticle < ApplicationRecord
  belongs_to  :article
  belongs_to  :user

  validates :article_id, presence: true
  validates :user_id, presence: true
  validates_uniqueness_of :user_id, scope: :article_id
end
