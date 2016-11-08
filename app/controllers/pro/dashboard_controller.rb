class Pro::DashboardController < Pro::ProController

  def dashboard
    session[:impersonate_id] = '48'
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
