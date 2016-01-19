class UserMailer < ApplicationMailer

  def welcome(current_user)
    mail to: current_user.email
  end
end
