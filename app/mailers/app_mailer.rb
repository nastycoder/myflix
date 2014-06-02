class AppMailer < ActionMailer::Base
  default from: "noreply@myflix.com"

  def welcome_user(user)
    @user = user
    mail subject: 'Welcome to MyFlix', to: user.email
  end

  def forgot_password(user)
    @user = user
    mail subject: "Seems you've forgotten your password", to: user.email
  end
end
