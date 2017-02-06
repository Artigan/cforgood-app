class CausesController < ApplicationController

  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @causes = Cause.all.includes(:cause_category)
  end

  def show
    @businesses = Business.active.with_perks_in_time.distinct.includes(:business_category)
    @cause  = Cause.joins(:cause_category).find(params[:id])
  end
end
