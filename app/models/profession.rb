class Profession < ApplicationRecord
  has_many :users
  has_many :topics

  validates :name, presence: true, allow_blank: false
end
