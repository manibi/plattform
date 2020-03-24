class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def welcome(user)
    @user = user

    mail(
      subject: 'Willkommen bei Mozubi!',
      to: @user.email,
      from: 'support@mozubi.app',
      track_opens: 'true'
    )
  end

  def welcome_another_profession(user)
    @user = user

    mail(
      subject: 'Willkommen bei Mozubi!',
      to: @user.email,
      from: 'support@mozubi.app',
      track_opens: 'true'
    )
  end
end
