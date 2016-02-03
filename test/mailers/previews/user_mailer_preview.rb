class UserMailerPreview < ActionMailer::Preview
  def registration
    user = User.last
    UserMailer.registration(user)
  end

  def activation
    user = User.first
    UserMailer.activation(user)
  end
end
