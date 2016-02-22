class PagesController < ApplicationController

  before_action :redirect_to_dasboard!

  def home
    @businesses = Business.joins(:perks).where("perks.active = ?", true).distinct
  end

  private

  def redirect_to_dasboard!
    if request['action'] != "faq_connect"
      redirect_to(member_user_dashboard_path(current_user)) if user_signed_in?
      redirect_to(pro_business_dashboard_path(current_business)) if business_signed_in?
    end
  end

end
