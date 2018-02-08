class UserMailer < ApplicationMailer
  default :from => "ywaghmare5203@gmail.com"
 
  def welcome_email(user)
  	puts "HHHHHHHHHHHHHHHH#{user.inspect}"
    @user = user
    @url  = "http://example.com/login"
    mail(:to => user.email, :subject => "Welcome to My Awesome Site")
  end
end
