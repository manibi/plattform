class TemporaryUserCredential < ApplicationRecord
  belongs_to :company
  belongs_to :profession

  enum role: [:student, :author, :admin]

  # VALID_EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\z/

  validates :exam_date, presence: true
  validate  :validate_dated_around_now
  validates_format_of :email,:with => Devise::email_regexp
  validates :first_name, presence: true, allow_blank: false
  validates :last_name, presence: true, allow_blank: false
  validates :company_name, presence: true, allow_blank: false
  validates :school_name, presence: true, allow_blank: false


  # Make sure exam_date isn't in the past or more than 5 years in the future
  def validate_dated_around_now
    self.errors.add(:exam_date, "ist kein korrektes Datum, bitte versuche es erneut.") unless ((Date.today)..(5.years.from_now)).include?(self.exam_date)
  end

end
