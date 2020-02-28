class UserCredential < ApplicationRecord
  belongs_to :user
  belongs_to :company
  belongs_to :profession
  enum role: [:student, :author, :admin]
end
