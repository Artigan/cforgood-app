class Api::V1::CausesController < Api::V1::BaseController

  before_action :set_cause, only: [ :show, :update ]

  def index
    @lat_lng = set_coordinates(params[:lat], params[:lng])

    @partner = Partner.find_by_code_partner(current_user.code_partner.upcase) if current_user.code_partner.present?
    if @partner && @partner.supervisor_id.present?
      @causes = Cause.where(supervisor_id: @partner.supervisor_id)
    else
      @causes = Cause.where.not(id: ENV['CAUSE_ID_CFORGOOD'].to_i).near(@lat_lng, 9999, order: "distance")
    end
    authorize @causes
  end

  def show
  end

  private

  def set_cause
    @cause = Cause.includes(:cause_category).find(params[:id])
    authorize @cause
  end
end
