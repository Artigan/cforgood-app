class  Api::V1::SessionsController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :verify_signed_out_user

  acts_as_token_authentication_handler_for User

  def create
    email = request.headers.env["HTTP_EMAIL"]
    password = request.headers.env["HTTP_PASSWORD"]

    if email.nil? or password.nil?
      render status: 400, json: { message: 'The request MUST contain the user email and password.' }
      return
    end

    user = User.find_by(email: email)

    if user && user.valid_password?(password)
      user.authentication_token = nil
      user.save
      render status: 200, json: { id: user.id, email: user.email, authentication_token: user.authentication_token }
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


  # prepend_before_filter :require_no_authentication, :only => [:create ]
#   include Devise::Controllers::InternalHelpers

#   before_filter :ensure_params_exist

#   respond_to :json

#   def create
#     build_resource
#     resource = User.find_for_database_authentication(:login=>params[:user_login][:login])
#     return invalid_login_attempt unless resource

#     if resource.valid_password?(params[:user_login][:password])
#       sign_in("user", resource)
#       render :json=> {:success=>true, :auth_token=>resource.authentication_token, :login=>resource.login, :email=>resource.email}
#       return
#     end
#     invalid_login_attempt
#   end

#   def destroy
#     sign_out(resource_name)
#   end

#   protected
#   def ensure_params_exist
#     return unless params[:user_login].blank?
#     render :json=>{:success=>false, :message=>"missing user_login parameter"}, :status=>422
#   end

#   def invalid_login_attempt
#     warden.custom_failure!
#     render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
#   end
# end
