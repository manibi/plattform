class TemporaryUserCredential < ApplicationRecord
  belongs_to :company
  belongs_to :profession

  enum role: [:student, :author, :admin]
end
