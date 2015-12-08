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

  def create
    @cause  = Cause.find(params[:id])
  end

  private

  def business_params
    params.require(:cause).permit(:name, :category, :description, :city, :zipcode, :street, :address, :email, :telephone)
  end
end
