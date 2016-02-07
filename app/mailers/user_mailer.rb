# class UserMailer < ApplicationMailer

#   def registration(current_user)
#     @user = current_user
#     mail(to: @user.email, subject: 'Bienvenue dans la communauté CforGood')
#   end

#   def activation(current_user)
#     @user = current_user
#     mail(to: @user.email, subject: 'Activation de votre espace CforGood')
#   end

# end


class UserMailer < BaseMandrillMailer

  def registration(current_user)

    subject = "Bienvenue dans la communauté CforGood"

    if current_user.first_name.present?
      name = current_user.first_name
    else
      nme = current_user.name
    end

    merge_vars = {
      "USER_NAME" => name,
      "PARTNER_NAME" => (Partner.find_by_code_promo(current_user.code_promo).name if current_user.code_promo.present?)
    }

    body = mandrill_template("User_registration", merge_vars)

    send_mail(current_user.email, subject, body)
  end

  def activation(current_user)

    subject = "Activation de votre espace CforGood"

    if current_user.first_name.present?
      name = current_user.first_name
    else
      nme = current_user.name
    end

    merge_vars = {
      "NAME" => name
    }

    body = mandrill_template("User_activation", merge_vars)

    send_mail(current_user.email, subject, body)
  end
end
