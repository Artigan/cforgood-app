class CausesController < ApplicationController

  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :get_coordinates, only: [:index, :show]

  def index
    if @partner && @partner.supervisor_id.present?
      @causes = Cause.where(supervisor_id: @partner.supervisor_id)
    else
      @causes = Cause.where.not(id: ENV['CAUSE_ID_CFORGOOD'].to_i).near(@lat_lng, 9999, order: "distance").includes(:cause_category)
    end
  end

  def show
    # save request.referer when logout access
    if !user_signed_in?
      session[:referer] = request.url
    else
      session.delete(:referer)
    end
    @businesses = Business.not_supervisor.includes(:business_category, :main_address).active.with_perks_in_time.distinct
    @cause  = Cause.joins(:cause_category).find(params[:id])
  end

  def new
     @cause = Cause.new
  end

  def create
    @cause = Cause.new(cause_params)
    if @cause.save
      redirect_to "https://www.cforgood.com/associations/"
    else
      render :new
    end
  end

  private

    def get_coordinates
      @lat_lng = set_coordinates(params[:lat], params[:lng])
    end

    def cause_params
      params.require(:cause).permit(:name, :description, :street, :zipcode, :city, :url, :email, :telephone, :impact, :cause_category_id, :facebook, :twitter, :instagram, :description_impact,
:representative_first_name, :representative_last_name, :amount_impact, :active, :link_video, :picture, :picture_cache, :logo, :logo_cache, :mailing, :tax_receipt, :followers, :heard)
    end

end
