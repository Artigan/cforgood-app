class Pro::DashboardController < Pro::ProController

  def dashboard
    @business = Business.find(params[:business_id])
    @perks = @business.perks
    authorize @business
  end

  def profile
    @business = Business.find(params[:business_id])
    current_business.addresses.build
    authorize @business
  end
end
