class Member::DashboardController < ApplicationController

  before_action :authenticate_user!
  # include Pundit

  # after_action :verify_authorized, except: :index, unless: :devise_controller?
  # after_action :verify_policy_scoped, only: :index, unless: :devise_controller?

  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def dashboard
    # @businesses = Business.for_map.joins(:perks).merge(Perk.in_time).distinct
    @businesses = Business.active.for_map.joins(:perks).merge(Perk.in_time).distinct

    @geojson = {"type" => "FeatureCollection", "features" => []}

    @businesses.each do |business|
      # ITINERANT BUSINESS
      if business.shop
        latitude = business.latitude
        longitude = business.longitude
      end
      if business.itinerant && business.addresses.active.today.count > 0
        if business.addresses.active.today.first.start_time.strftime('%R') <= Time.now.strftime('%R') && business.addresses.active.today.first.end_time.strftime('%R') >= Time.now.strftime('%R')
          latitude = business.addresses.active.today.first.latitude
          longitude = business.addresses.active.today.first.longitude
        end
      end
      if !latitude.present? || !longitude.present?
        next
      end
      # EVERY BUSINESS
      @geojson["features"] << {
        "type": 'Feature',
        "geometry": {
          "type": 'Point',
          "coordinates": [longitude, latitude]
        },
        "properties": {
          "marker-symbol": business.business_category.marker_symbol,
          "description": render_to_string(partial: "components/map_box", locals: { business: business, flash: false })
        }
      }
      # ONLY BUSINESS WITH FLASH PERK
      if business.perks.flash_in_time.count > 0
        @geojson["features"] << {
          "type": 'Feature',
          "geometry": {
            "type": 'Point',
            "coordinates": [longitude, latitude]
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
