class BusinessesController < ApplicationController

  before_action :authenticate_user!

  def index
    @businesses = Business.active.joins(:perks).active.distinct
  end

  def show
    @business = Business.find(params[:id])

    @geojson = {"type" => "FeatureCollection", "features" => []}

    @geojson["features"] << {
      "type": 'Feature',
      "geometry": {
        "type": 'Point',
        "coordinates": [@business.longitude, @business.latitude],
      },
      "properties": {
        "marker-symbol": @business.business_category.marker_symbol
      }
    }
    respond_to do |format|
      format.html
      format.json{render json: @geojson}
    end
  end
end
