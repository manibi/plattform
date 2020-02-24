class Company < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :authentication_keys => [:username]

  validates :name, presence: true, allow_blank: false
  validates_format_of :phone_number,
                      :with => /\A\d*\z/,
                      :message => "- Phone numbers must be not valid."

  has_many :users
  has_many :professions, through: :users

  def students_for(profession)
    Company.first.users.where(profession: profession)
  end
end
