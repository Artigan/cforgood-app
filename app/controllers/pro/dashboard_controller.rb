class Pro::DashboardController < Pro::ProController

  def dashboard
    @business = Business.find(params[:business_id])
    @perks = @business.perks
    authorize @business

    @businesses = Business.joins(:perks).where("perks.permanent = ?", true).distinct

    # Let's DYNAMICALLY build the markers for the view.
    @markers = Gmaps4rails.build_markers(@businesses) do |business, marker|
      marker.lat business.latitude
      marker.lng business.longitude
      if business.id == current_business.id
        marker.title "C'est vous !"
      end
      marker.picture({
        url: BusinessCategory.find(business.business_category_id).marker.url(:marker),
        width: 40,
        height: 43
      })
      marker.infowindow render_to_string(partial: "components/map_box", locals: { business: business })
    end
  end

  def profile
    @business = Business.find(params[:business_id])
    authorize @business
  end
end
