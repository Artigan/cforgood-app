  class BusinessesController < ApplicationController

  before_action :authenticate_user!

  def index
    @businesses = Business.joins(:perks).where("perks.permanent = ?", true).distinct
  end

  def show
    @business = Business.find(params[:id])

    @geojson = Array.new
    @geojson << {
      type: 'Feature',
      geometry: {
        type: 'Point',
        coordinates: [@business.longitude, @business.latitude]
      },
      properties: {
        icon: {
          iconUrl: BusinessCategory.find(@business.business_category_id).marker.url,
          iconSize: [40, 43],
          # iconAnchor: [25, 25],
          # popupAnchor: [0, -25]
        }
      }
    }
    respond_to do |format|
      format.html
      format.json{render json: @geojson}
    end
  end
end
