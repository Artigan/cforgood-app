class Member::DashboardController < ApplicationController

  before_action :authenticate_user!
  # include Pundit

  # after_action :verify_authorized, except: :index, unless: :devise_controller?
  # after_action :verify_policy_scoped, only: :index, unless: :devise_controller?

  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def dashboard
    @businesses = Business.where(online: false).joins(:perks).where("perks.permanent = ?", true).distinct

    @geojson = {"type" => "FeatureCollection", "features" => []}

    @businesses.each do |business|
      @geojson["features"] << {
        "type": 'Feature',
        "geometry": {
          "type": 'Point',
          "coordinates": [business.longitude, business.latitude]
        },
        "properties": {
          "marker-symbol": business.business_category.marker_symbol,
          "description": render_to_string(partial: "components/map_box", locals: { business: business })
        }
      }
    end
    respond_to do |format|
      format.html
      format.json{render json: @geojson}
    end
  end
end
