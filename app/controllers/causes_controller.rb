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
    @businesses = Business.active.with_perks_in_time.distinct.includes(:business_category)
    @cause  = Cause.joins(:cause_category).find(params[:id])
  end
end
