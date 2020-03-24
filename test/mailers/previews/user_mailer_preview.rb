# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/welcome
  def welcome
    UserMailer.welcome(TemporaryUserCredential.last)
  end

  def welcome_another_profession
    UserMailer.welcome_another_profession(TemporaryUserCredential.last)
  end

end
