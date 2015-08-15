class BusinessesController < ApplicationController

  def index
    @businesses = Business.all

    # Let's DYNAMICALLY build the markers for the view.
    @markers = Gmaps4rails.build_markers(@businesses) do |business, marker|
      marker.lat business.latitude
      marker.lng business.longitude
      marker.infowindow render_to_string(partial: "/businesses/map_box", locals: { business: business })
    end
  end

  def show
    @business = Business.find(params[:id])
    @markers = Gmaps4rails.build_markers(@business) do |business, marker|
      marker.lat business.latitude
      marker.lng business.longitude
    end
  end

  def new
    @business   = Business.new
  end

  def create
    @business   = Business.find(params[:id])
  end

  def business_params
    params.require(:business).permit(:name, :category, :perk, :description, :city, :zipcode, :street, :address, :email, :telephone, :latitude, :longitude)
  end

end