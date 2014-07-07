class AppMailer < ActionMailer::Base
  default from: "noreply@myflix-uriah.herokuapp.com"

  def welcome_user(user)
    @user = user
    mail subject: 'Welcome to MyFlix', to: user.email
  end

  def forgot_password(user)
    @user = user
    mail subject: "Seems you've forgotten your password", to: user.email
  end

  def invitation(invite)
    @invite = invite
    mail subject: "#{@invite.user.full_name} has invited you to join MyFlix", to: @invite.email
  end

  def deactivation_notice(user)
    @user = user
    mail subject: 'Your Myflix account has been deactivated', to: user.email
  end
end
