class BusinessesController < ApplicationController
  def index
    @businesses = Business.all
  end

  def show
    @business = Business.find(params[:id])
  end

  def business_params
      params.require(:business).permit(:name, :category, :perk, :description, :city, :zipcode, :street, :address, :email, :telephone)
  end
end