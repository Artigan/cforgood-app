class BusinessesController < ApplicationController

  before_action :authenticate_user!

  def index
    @businesses = Business.joins(:perks).where("perks.permanent = ?", true).distinct

    # Let's DYNAMICALLY build the markers for the view.
    @markers = Gmaps4rails.build_markers(@businesses) do |business, marker|
      marker.lat business.latitude
      marker.lng business.longitude
      marker.picture({
        url: BusinessCategory.find(business.business_category_id).picture.url(:marker),
        width: 32,
        height: 32
      })
      marker.infowindow render_to_string(partial: "components/map_box", locals: { business: business })
    end
  end

  def show
    @business = Business.find(params[:id])
    @markers = Gmaps4rails.build_markers(@business) do |business, marker|
      marker.lat business.latitude
      marker.lng business.longitude
      marker.picture({
        url: BusinessCategory.find(business.business_category_id).picture.url(:marker),
        width: 32,
        height: 32
      })
    end
  end
end
