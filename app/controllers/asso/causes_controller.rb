class Asso::CausesController < ApplicationController

  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @causes = Cause.all.includes(:cause_category)
  end

  def show
    # save logout access
    if !user_signed_in?
      session[:logout] = true
    end

    @cause  = Cause.joins(:cause_category).find(params[:id])
  end
end
