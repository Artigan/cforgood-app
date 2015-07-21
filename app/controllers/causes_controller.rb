class CausesController < ApplicationController
  def index
    @causes = Cause.all
  end

  def show
    @cause  = Cause.find(params[:id])
  end

  def new
    @cause  = Cause.new
  end
end