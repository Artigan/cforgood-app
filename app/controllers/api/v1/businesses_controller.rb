class Api::V1::BusinessesController < Api::V1::BaseController

  before_action :set_business, only: [ :show ]

  def index
    @lat_lng = set_coordinates(params[:lat], params[:lng])
    if params[:online].present? && params[:online] == "true"
      @businesses = Business.includes(:business_category, :main_address).active.with_perks_in_time.distinct.eager_load(:addresses_for_map).merge(Address.near(@lat_lng, 9999, order: "distance"))
    else
      @businesses = Business.includes(:business_category, :perks_in_time, :uses, :main_address).active.for_map.with_perks_in_time.distinct.eager_load(:addresses_for_map).merge(Address.near(@lat_lng, 10))
    end
    authorize @businesses
  end

  def show
    @address = Address.includes(:timetables).find(params[:address_id])
  end

  private

  def set_business
    @business = Business.includes(:label_categories, :perks_in_time).find(params[:id])
    authorize @business
  end
end
