class Asso::CausesController < ApplicationController

  before_action :authenticate_user!

  def index
    @causes = Cause.all
  end

  def show
    @cause  = Cause.find(params[:id])
  end
end
