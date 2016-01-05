class Pro::BusinessesController < Pro::ProController

  before_action :find_business, only: [:show, :edit, :update]

  raise
  def show
    @perks = @business.perks
    authorize @business
  end

  def update
    if @business.update(business_params)
      redirect_to pro_business_dashboard_path(@business)
    else
     render :edit
    end
  end

  private

  def find_business
    @business = Business.find(params[:id])
    authorize @business
  end

end
