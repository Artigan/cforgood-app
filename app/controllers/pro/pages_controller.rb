class Pro::PagesController < Pro::ProController

  def home
    @business = Business.find(params[:business_id])
    @perks = @business.perks
    authorize @business
  end

end
