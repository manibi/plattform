class Profession < ApplicationRecord
  has_many :users
  has_many :topics, dependent: :destroy
  has_many :user_credentials
  has_many :companies, through: :users

  validates :name, presence: true, allow_blank: false

  def students
    User.student.where(profession: self)
  end
end
