# class BusinessMailer < ApplicationMailer

#   def registration(current_business)
#     @business = current_business
#     mail(to: @business.email, subject: 'Bienvenue dans la communauté CforGood')
#   end

#   def activation(current_business)
#     @business = current_business
#     mail(to: @business.email, subject: 'Activation de votre espace CforGood')
#   end

# end


class BusinessMailer < BaseMandrillMailer

  def registration(current_business)

    subject = "Bienvenue dans la communauté CforGood"
    merge_vars = {
      "NAME" => current_business.name
    }
    body = mandrill_template("Business_registration", merge_vars)

    send_mail(current_business.email, subject, body)
  end

  def activation(current_business)

    subject = "Activation de votre espace CforGood"
    merge_vars = {
      "NAME" => current_business.name
    }
    body = mandrill_template("Business_activation", merge_vars)

    send_mail(current_business.email, subject, body)
  end
end
