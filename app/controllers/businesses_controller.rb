  class BusinessesController < ApplicationController

  before_action :authenticate_user!

  def index
    @businesses = Business.joins(:perks).where("perks.permanent = ?", true).distinct
  end

  def show
    @business = Business.find(params[:id])

    @geojson = {"type" => "FeatureCollection", "features" => []}

    @geojson["features"] << {
      "type": 'Feature',
      "geometry": {
        "type": 'Point',
        "coordinates": [@business.longitude, @business.latitude]
      },
      "properties": {
        # "marker-symbol": ("." + business.business_category_id.to_s),
        "marker-symbol": "monument",
        # "description": render_to_string(partial: "components/map_box", locals: { business: business })
      }
    }
    respond_to do |format|
      format.html
      format.json{render json: @geojson}
    end
  end
end
