class UserMailer < ApplicationMailer

  def welcome(current_user)
    @user = current_user
    mail(to: @user.email, subject: 'Bienvenue dans la communauté CforGood')
  end
end
