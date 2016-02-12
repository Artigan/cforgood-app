class Member::DashboardController < ApplicationController

  before_action :authenticate_user!
  # include Pundit

  # after_action :verify_authorized, except: :index, unless: :devise_controller?
  # after_action :verify_policy_scoped, only: :index, unless: :devise_controller?

  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def dashboard
    @businesses = Business.where(online: false).joins(:perks).where("perks.permanent = ?", true).distinct

    @geojson = Array.new

    @businesses.each do |business|
      @geojson << {
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: [business.longitude, business.latitude]
        },
        properties: {
          "marker-symbol": ("." + business.business_category_id.to_s),
          "show_on_map": true,
          popupContent: render_to_string(partial: "components/map_box", locals: { business: business }),
          icon: {
            iconUrl: BusinessCategory.find(business.business_category_id).marker.url,
            iconSize: [40, 43],
            iconAnchor: [25, 25],
            popupAnchor: [0, -25]
          }
        }
      }
    end
    respond_to do |format|
      format.html
      format.json{render json: @geojson}
    end
  end
end
