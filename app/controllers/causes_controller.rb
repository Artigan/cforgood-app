class BusinessesController < ApplicationController
  def index
    @causes = Cause.all
  end

  def show
    @cause = Cause.find(params[:id])
  end

  def business_params
    params.require(:cause).permit(:name, :type, :description, :city, :zipcode, :street, :address, :email, :telephone)
  end
end