class BusinessesController < ApplicationController

  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @businesses = Business.active.with_perks_in_time.distinct.includes(:business_category)
    @addresses_id = []
    @businesses.each do |business|
      business.addresses.shop.each do |address_shop|
        @addresses_id << [business.id, address_shop.id]
      end
      if business.itinerant
        business.addresses.today.each do |address_itinerant|
           @addresses_id << [business.id, address_itinerant.id]
        end
      end
    end
    @addresses_id.delete([]) # REMOVE WHEN NO ACTIVE RECORD ASSOCIATION
  end

  def businesses_index
    @businesses = Business.all
  end

  def show
    # save request.referer when logout access
    if !user_signed_in?
      session[:referer] = request.url
    else
      session.delete(:referer)
    end
    @businesses = Business.includes(:main_address).active.with_perks_in_time.distinct.includes(:business_category)
    @business = Business.joins(:business_category).find(params[:id])
    @address = Address.find(params[:address_id])

    @geojson = {"type" => "FeatureCollection", "features" => []}

    @geojson["features"] << {
      "type": 'Feature',
      "geometry": {
        "type": 'Point',
        "coordinates": [@address.longitude, @address.latitude],
      },
      "properties": {
        "marker-symbol": @business.business_category.marker_symbol,
        "color": @business.business_category.color
      }
    }
    respond_to do |format|
      format.html
      format.json{render json: @geojson}
    end
  end
end
