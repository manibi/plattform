class Topic < ApplicationRecord
  belongs_to  :profession
  has_many    :articles, dependent: :destroy

  validates :name, presence: true, allow_blank: false
  validates :profession_id, presence: true
end
