class Pro::DashboardController < Pro::ProController

  skip_after_action :verify_authorized, only: [:set_impersonation, :reset_impersonation]
  before_action :find_business, only: [:dashboard, :profile]

  def set_impersonation
    if current_business.supervising?(params[:impersonate_id])
      session[:impersonate_id] = params[:impersonate_id]
    else
      session[:impersonate_id] = nil
    end
    redirect_to pro_business_dashboard_path(current_business)
  end

  def reset_impersonation
    session[:impersonate_id] = nil
    redirect_to pro_business_dashboard_path(current_business)
  end

  def dashboard
    @perks = @business.perks
    authorize @business
  end

  def profile
    authorize @business
  end

  def supervisor_dashboard
    @business = current_business
    @main_address = @business.main_address
    # A modifier !!!
    # @perks = @business.businesses_perks
    authorize @business

    @geojson = {"type" => "FeatureCollection", "features" => []}

    if current_business.admin
      @businesses = Business.all.includes(:addresses, :business_category, :perks).eager_load(:businesses_perks, :businesses_perks_uses)
    else
      @businesses = @business.businesses.includes(:addresses, :business_category, :perks).eager_load(:businesses_perks, :businesses_perks_uses)
    end

    @businesses.each do |business|
      business.addresses.each do |address|
        @geojson["features"] << {
          "type": 'Feature',
          "geometry": {
            "type": 'Point',
            "coordinates": [address.longitude, address.latitude]
          },
          "properties": {
            "marker-symbol": business.business_category.marker_symbol,
            "color": business.business_category.color
          }
        }
      end
    end
  end

  private

  def find_business
    id = session[:impersonate_id] || params[:business_id]
    @business = Business.includes(:manager).find(id)
  end
end
