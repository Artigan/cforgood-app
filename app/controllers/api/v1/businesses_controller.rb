class Api::V1::BusinessesController < Api::V1::BaseController

  before_action :set_business, only: [ :show ]

  def index
    @lat_lng = set_coordinates(params[:lat], params[:lng])
    if params[:online].present? && params[:online] == "true"
      @businesses = Business.not_supervisor.includes(:business_category, :main_address, :labels, :label_categories).active.with_perks_in_time.distinct.eager_load(:addresses).merge(Address.near(@lat_lng, 99999, order: "distance"))
    else
      @businesses = Business.not_supervisor.includes(:business_category, :main_address, :labels, :label_categories).active.for_map.with_perks_in_time.distinct.eager_load(:addresses_for_map).merge(Address.near(@lat_lng, 99999, order: "distance"))
    end
    authorize @businesses
    current_user.create_event_no_business(@lat_lng) if @businesses.empty?
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
