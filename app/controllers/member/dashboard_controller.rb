class Member::DashboardController < ApplicationController

  before_action :authenticate_user!
  # include Pundit

  # after_action :verify_authorized, except: :index, unless: :devise_controller?
  # after_action :verify_policy_scoped, only: :index, unless: :devise_controller?

  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def dashboard
    @businesses = Business.joins(:perks).where("(businesses.active = true and (businesses.shop = true or businesses.itinerant = true) and perks.active = true)").distinct

    @geojson = {"type" => "FeatureCollection", "features" => []}

    @businesses.each do |business|
      # EVERY BUSINESS
      @geojson["features"] << {
        "type": 'Feature',
        "geometry": {
          "type": 'Point',
          "coordinates": [business.longitude, business.latitude]
        },
        "properties": {
          "marker-symbol": business.business_category.marker_symbol,
          "description": render_to_string(partial: "components/map_box", locals: { business: business, flash: false })
        }
      }
      # ONLY BUSINESS WITH FLASH PERK
      if business.perks.where("active = ? and flash = ? and start_date <= ? and end_date >= ?", true, true, Time.now, Time.now).count > 0
        @geojson["features"] << {
          "type": 'Feature',
          "geometry": {
            "type": 'Point',
            "coordinates": [business.longitude, business.latitude]
          },
          "properties": {
            "marker-symbol": business.business_category.marker_symbol+"-flash",
            "description": render_to_string(partial: "components/map_box", locals: { business: business, flash: true })
          }
         }
      end
    end

    respond_to do |format|
      format.html
      format.json{render json: @geojson}
    end
  end
end
