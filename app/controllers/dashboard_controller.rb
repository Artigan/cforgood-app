class DashboardController < ApplicationController

  before_action :authenticate_user!
  # include Pundit

  # after_action :verify_authorized, except: :index, unless: :devise_controller?
  # after_action :verify_policy_scoped, only: :index, unless: :devise_controller?

  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def dashboard
    @businesses = Business.joins(:perks).where("perks.permanent = ?", true)
    # Let's DYNAMICALLY build the markers for the view.
    @markers = Gmaps4rails.build_markers(@businesses) do |business, marker|
      marker.lat business.latitude
      marker.lng business.longitude
      marker.infowindow render_to_string(partial: "/businesses/map_box", locals: { business: business })
    end
  end

end