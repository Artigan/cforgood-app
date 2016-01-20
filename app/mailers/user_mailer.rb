class UserMailer < ApplicationMailer

  def registration(current_user)
    @user = current_user
    mail(to: @user.email, subject: 'Bienvenue dans la communauté CforGood')
  end

  def activation(current_user)
    @user = current_user
    mail(to: @user.email, subject: 'Activation de votre espace CforGood')
  end

end
