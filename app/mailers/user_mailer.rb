class UserMailer < ActionMailer::Base
  default :from => AppConfig['email_from']

  def reset_password(user)
    @user = user
    mail(:to => user.email, :subject => "Astrology.com - Resetting the password")
  end

end
