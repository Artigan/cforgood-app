class Api::V1::BusinessesController < Api::V1::BaseController

  before_action :set_business, only: [ :show ]

  def index
    @lat_lng = set_coordinates(params[:lat], params[:lng])
    if params[:online].present? && params[:online] == "true"
      @businesses = Business.not_supervisor.includes(:perks, :business_category, :labels, :label_categories, :addresses).active.with_perks_in_time.distinct.merge(Address.near(@lat_lng, 99999, order: "distance"))
    else
      @businesses = Business.not_supervisor.includes(:perks, :business_category, :labels, :label_categories, :addresses).active.for_map.with_perks_in_time.distinct.merge(Address.near(@lat_lng, 99999, order: "distance"))
    end
    authorize @businesses
    # event for no business around
    current_user.create_event_no_business(@lat_lng) if @businesses.merge(Address.near(@lat_lng, 50)).size == 0
    # event for ecosystem change
    ecosystem_now = Ecosystem.within(@lat_lng).first.try(:name) if is_number?(params[:lat]) && is_number?(params[:lng])
    current_user.create_event_last_ecosystem_seen(ecosystem_now) if ecosystem_now.present? && ecosystem_now != current_user.last_ecosystem_seen
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
