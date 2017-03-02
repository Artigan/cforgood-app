class CausesController < ApplicationController

  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @causes = Cause.all.includes(:cause_category)
  end

  def show
    # save request.referer when logout access
    if !user_signed_in?
      session[:referer] = request.url
    else
      session.delete(:referer)
    end
    @businesses = Business.includes(:business_category, :main_address).active.with_perks_in_time.distinct
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

    def cause_params
    params.require(:cause).permit(:name, :description, :street, :zipcode, :city, :url, :email, :telephone, :impact, :cause_category_id, :facebook, :twitter, :instagram, :description_impact,
:representative_first_name, :representative_last_name, :amount_impact, :active, :link_video, :picture, :picture_cache, :logo, :logo_cache, :mailing, :tax_receipt, :followers, :heard)

    end

end
