class Pro::DashboardController < Pro::ProController

  def dashboard
    if current_business.supervising?(params[:impersonate_id])
      session[:impersonate_id] = params[:impersonate_id]
    else
      session[:impersonate_id] = nil
    end
    Rails.logger.info("*" * 15)
    Rails.logger.info(session[:impersonate_id])
    Rails.logger.info("*" * 15)
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
