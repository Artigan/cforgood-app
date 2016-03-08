class PagesController < ApplicationController

  before_action :redirect_to_dasboard!

  def home
    @businesses = Business.active.joins(:perks).active.distinct
  end

  def newsletter
    @result = SubscribeToNewsletter.new(params[:newsletter]).run
    respond_to do |format|
      format.html {redirect_to :back}
      format.js { @result }
    end
  end

  private

  def redirect_to_dasboard!
    if request['action'] != "faq_connect"
      return redirect_to(member_user_dashboard_path(current_user)) if user_signed_in?
      return redirect_to(pro_business_dashboard_path(current_business)) if business_signed_in?
    end
  end

end
