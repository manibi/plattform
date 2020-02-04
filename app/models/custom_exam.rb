class CustomExam < ApplicationRecord
  belongs_to :user

  serialize :questions, Array
end
