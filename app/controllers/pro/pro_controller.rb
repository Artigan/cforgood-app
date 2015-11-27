class Pro::ProController < ApplicationController

  layout 'pro'

  before_action :authenticate_business!
  include Pundit

  after_action :verify_authorized, except: :index, unless: :devise_controller?
  after_action :verify_policy_scoped, only: :index, unless: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(pro_business_metrics_path(current_business))
  end

  def pundit_user
    current_business
  end

end
