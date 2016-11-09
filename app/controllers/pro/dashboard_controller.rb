class Pro::DashboardController < Pro::ProController
  
  skip_after_action :verify_authorized, only: :set_impersonation

  def set_impersonation
    if current_business.supervising?(params[:impersonate_id])
      session[:impersonate_id] = params[:impersonate_id]
    else
      session[:impersonate_id] = nil
    end
    redirect_to :back
  end

  def dashboard
    @business = Business.find(params[:business_id])
    @perks = @business.perks
    authorize @business
  end

  def profile
    @business = Business.find(params[:business_id])
    5.times{ current_business.addresses.build }
    authorize @business
  end
end
