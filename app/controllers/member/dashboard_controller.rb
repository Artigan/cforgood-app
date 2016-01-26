class Member::DashboardController < ApplicationController

  before_action :authenticate_user!
  # include Pundit

  # after_action :verify_authorized, except: :index, unless: :devise_controller?
  # after_action :verify_policy_scoped, only: :index, unless: :devise_controller?

  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def dashboard
    @businesses = Business.joins(:perks).where("perks.permanent = ?", true).distinct
    # authorize @businesses
    # Let's DYNAMICALLY build the markers for the view.
    @markers = Gmaps4rails.build_markers(@businesses) do |business, marker|
      marker.lat business.latitude
      marker.lng business.longitude
      marker.picture({
        url: BusinessCategory.find(business.business_category_id).marker.url(:marker),
        width: 40,
        height: 43
      })
      marker.infowindow render_to_string(partial: "components/map_box", locals: { business: business })
    end
  end
end
