class BusinessesController < ApplicationController

  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_coordinates, only: [:index, :show]
  before_action :find_businesses_for_search, only: [:index, :show]

  def index
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
    @business = @businesses.find(params[:id])
    @address = @business.addresses.find(params[:address_id])
    @labels = @business.labels.includes(:label_category)

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

  private

  def set_coordinates
    if params[:lng].present? && params[:lat].present?
      @lat_lng = [params[:lat], params[:lng]]
    elsif (current_user.present? && current_user.email == "allan.floury@gmail.com") || !cookies[:coordinates].present?
      @lat_lng = [44.837789, -0.57918]
    else
      @lat_lng = cookies[:coordinates].split('&')
    end
  end

  def find_businesses_for_search
    @businesses = Business.includes(:business_category, :main_address).active.with_perks_in_time.distinct.eager_load(:addresses_for_map).merge(Address.near(@lat_lng, 9999, order: "distance"))
  end
end
