class Asso::CausesController < ApplicationController

  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @causes = Cause.all
  end

  def show
    @cause  = Cause.find(params[:id])
  end
end
