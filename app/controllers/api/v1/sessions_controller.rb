class  Api::V1::SessionsController < Devise::SessionsController

  skip_before_action :verify_authenticity_token, except: [ :create ]
  skip_before_action :verify_signed_out_user

  acts_as_token_authentication_handler_for User, except: [ :create ]

  def create
    email = request.headers.env["HTTP_EMAIL"].downcase if request.headers.env["HTTP_EMAIL"].present?
    password = request.headers.env["HTTP_PASSWORD"] if request.headers.env["HTTP_PASSWORD"].present?
    access_token = request.headers.env["HTTP_ACCESS_TOKEN"] if request.headers.env["HTTP_ACCESS_TOKEN"].present?

    if ! (email.present? && ( password.present? || access_token.present? ))
      return render status: 400, json: { message: 'The request MUST contains the user email and password or facebook_token.' }
    end

    @user = User.find_by(email: email)

    return render status: 401, json: { errors: 'Invalid email' } if !@user
    return render status: 401, json: { errors: 'Invalid password' } if password.present? && !@user.valid_password?(password)
    # return render status: 401, json: { errors: 'Vous devez vous connecter une première fois avec facebook sur la webapp ou utiliser la connexion par email'} if access_token.present? && !@user.token.present?
    # return render status: 401, json: { errors: 'Invalid token facebook' } if access_token.present? && @user.token != access_token

    if access_token.present?
      url = "https://graph.facebook.com/me?access_token="
      begin
        content = open(URI.encode(url + access_token))
      rescue OpenURI::HTTPError #with this I handle if the access token is not ok
        return render status: 401, :json => {:error => "Invalid token facebook'" }
      end
    end

    @user.authentication_token = nil
    if @user.save
      render status: 200, json: { id: @user.id, email: @user.email, authentication_token: @user.authentication_token }
    end

  end

  def destroy
    user = current_user
    if user
      user.authentication_token = nil
      user.save
      render status: 200, json: { message: 'Disconnected' }
    else
      render status: 404, json: { message: 'Invalid User' }
    end
  end
end
