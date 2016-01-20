class BusinessMailer < ApplicationMailer

  def registration(current_business)
    @business = current_business
    mail(to: @business.email, subject: 'Bienvenue dans la communauté CforGood')
  end

  def activation(current_business)
    @business = current_business
    mail(to: @business.email, subject: 'Activation de votre espace CforGood')
  end

end
