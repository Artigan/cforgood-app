class Api::V1::CausesController < Api::V1::BaseController

  acts_as_token_authentication_handler_for User
  before_action :set_cause, only: [ :show ]

  def index
    @lat_lng = set_coordinates(params[:lat], params[:lng])

    @partner = Partner.find_by_code_partner(current_user.code_partner.upcase) if current_user.code_partner.present?
    if @partner && @partner.supervisor_id.present?
      @causes = Cause.where(supervisor_id: @partner.supervisor_id)
    else
      @causes = Cause.where.not(id: ENV['CAUSE_ID_CFORGOOD'].to_i).near(@lat_lng, 99999, order: "distance")
    end
    authorize @causes
  end

  def show
  end

  def create
    @cause = Cause.new(cause_params)
    authorize @cause
    if @cause.save
      render status: 200, json: { id: @cause.id }
    else
      render status: :unprocessable_entity, json: { error: @cause.errors.full_messages}
    end
  end

  private

  def set_cause
    @cause = Cause.includes(:cause_category).find(params[:id])
    authorize @cause
  end

  def cause_params
    params.require(:cause).permit(
      :id,
      :civility,
      :representative_first_name,
      :representative_last_name,
      :email,
      :cause_category_id,
      :name,
      :impact,
      :description,
      :street,
      :zipcode,
      :city
    )
  end
end
