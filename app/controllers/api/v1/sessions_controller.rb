class  Api::V1::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token
  skip_before_action :verify_signed_out_user

  acts_as_token_authentication_handler_for User

  def create

    email = request.headers.env["HTTP_EMAIL"].downcase if request.headers.env["HTTP_EMAIL"].present?
    password = request.headers.env["HTTP_PASSWORD"] if request.headers.env["HTTP_EMAIL"].present?
    access_token = request.headers.env["HTTP_ACCES_TOKEN"] if request.headers.env["HTTP_ACCES_TOKEN"].present?

    if !email.present? && ( !password.present? || !access_token.present? )
      render status: 400, json: { message: 'The request MUST contains the user email and password or facebook_token.' }
      return
    end

    @user = User.find_by(email: email)

    if access_token.present?
      binding.pry
      # @user_facebook = User.find_for_facebook_oauth(request.env['omniauth.auth'], @user)
    end

    binding.pry

    if @user && @user.valid_password?(password)
      @user.authentication_token = nil
      @user.save
      render status: 200, json: { id: @user.id, email: @user.email, authentication_token: @user.authentication_token }
    else
      render status: 401, json: { errors: 'Invalid email or password.' }
    end
  end

  def destroy
    user = current_user
    if user
      user.authentication_token = nil
      user.save
      render status: 200, json: { message: 'Disconnected' }
    else
      render status: 404, json: { message: 'Invalid User.' }
    end
  end
end
