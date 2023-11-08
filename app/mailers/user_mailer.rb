class UserMailer < ApplicationMailer
  default from: "saurabhsingh@gmail.com"
  layout "mailer"

  def welcome_email
    @user = params[:user]
    @url = "http://localhost:3000/api/v1/books"
    mail(to: @user.email, subject: "test email.")
  end
end
