class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def welcome(user)
    @user = user

    mail(
      subject: 'Welcome',
      to: @user.email,
      from: 'support@mozubi.app',
      track_opens: 'true'
    )

    # mail(
      # :subject => 'Hello from Postmark',
      # :to  => 'cristian.cristea@mozubi.app',
      # :from => 'support@mozubi.app',
      # :html_body => '<strong>Welcome to Mozubi</strong>.',
      # :track_opens => 'true')
  end
end
