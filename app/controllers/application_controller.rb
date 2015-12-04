class ApplicationController < ActionController::Base
  #include Pundit

  protect_from_forgery with: :exception

  before_action :set_layout

  #before_action :authenticate_user!, unless: :pages_controller?

  before_filter :configure_permitted_parameters, if: :devise_controller?
  # before_action :configure_permitted_parameters, if: :devise_controller

  # after_action :verify_authorized, except:  :index, unless: :devise_or_pages_controller?
  # after_action :verify_policy_scoped, only: :index, unless: :devise_or_pages_controller?

  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def after_sign_in_path_for(resource)
    if resource.sign_in_count == 1
      current_user.create_mangopay_user!
      new_account_path
    elsif resource_name == :business
      pro_business_metrics_path(resource)
    else
      dashboard_path
      # businesses_path
    end
  end

  private

  def set_layout
    if devise_controller?
      self.class.layout "sign"
    else
      self.class.layout "application"
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password, :remember_me, :password_confirmation, :name, :business_category_id, :city) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :current_password, :password_confirmation, :business_category_id, :name, :picture, :leader_picture, :street, :zipcode, :city, :url, :telephone, :description, :facebook, :twitter, :instagram) }
  end

  def businesses_controller?
    controller_name == "businesses"
  end

  def devise_or_pages_controller?
    devise_controller? || pages_controller?
  end

  def pages_controller?
    controller_name == "pages"  # Brought by the `high_voltage` gem
  end

  def user_not_authorized
    flash[:error] = I18n.t('controllers.application.user_not_authorized', default: "Vous ne pouvez pas accéder à cette page.")
    redirect_to(root_path)
  end

end
