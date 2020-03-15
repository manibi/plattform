class Company < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :authentication_keys => [:username]

  validates :name, presence: true, uniqueness: true, allow_blank: false
  validates_format_of :phone_number,
                      :with => /\A\d*\z/,
                      :message => "- Phone numbers must be not valid."

  has_many :users
  has_many :user_credentials
  has_many :temporary_user_credentials
  has_many :professions, through: :users

  def users_for(profession)
    self.users.where(profession: profession)
  end
end
