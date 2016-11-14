class ApplicationController < ActionController::Base

  include Mobvious::Rails::Controller

  protect_from_forgery with: :null_session

  before_action :set_layout

  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def after_sign_in_path_for(resource)

    cookies.permanent[:user_cforgood] = {
      value: 'login',
      domain: ENV['COOKIES_DOMAIN']
    }

    if resource.class.name == "Business"
      pro_business_dashboard_path(resource)
    else
      if !current_user.mangopay_id.present?
        begin
          @mangopay_user = MangopayServices.new(current_user).create_mangopay_natural_user
          current_user.update_attribute(:mangopay_id, @mangopay_user["Id"])
        rescue MangoPay::ResponseError => e
        end
        new_member_subscribe_path
      else
        member_user_dashboard_path(resource)
      end
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    cookies.delete(:user_cforgood, domain: ENV['COOKIES_DOMAIN'])
    root_path
  end

  private

  def set_layout
    if pages_admin?
      @_action_has_layout = false
      return
    elsif devise_controller? || user_signed_in?
      self.class.layout "application"
    else
      self.class.layout "website"
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password, :remember_me, :password_confirmation, :name, :business_category_id, :city, :zipcode, :code_partner) }
    devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:email, :password, :remember_me) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:email, :password, :current_password, :password_confirmation, :business_category_id, :name, :cause_id, :first_name, :last_name, :picture, :leader_picture, :street, :zipcode, :city, :url, :telephone, :description, :facebook, :twitter, :instagram, :subscription, :shop, :online, :itinerant) }
  end

  def pages_admin?
    controller_path.start_with?("admin/")
  end

  def user_not_authorized
    flash[:error] = I18n.t('controllers.application.user_not_authorized', default: "Vous ne pouvez pas accéder à cette page.")
    redirect_to(root_path)
  end
end
