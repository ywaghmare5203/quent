class UserMailer < ApplicationMailer
  default :from => "ywaghmare5203@gmail.com"
  def welcome_email(user, url)
    @user = user
    @url  = url
    mail(:to => user.email, :subject => "Welcome to My Awesome Site")
  end


  def password_reset(user, url)
  	@user = user
    @url  = url
    mail(:to => user.email, :subject => "Welcome to My Awesome Site")
  end
end
