class AddressesController < ApplicationController

  before_action :find_address, only: [:edit, :update, :destroy]

  def create
    @address = @business.addresses.build(address_params)
    authorize @address
    respond_to do |format|
      if @address.save
        format.html { redirect_to pro_business_profile_path(@business) }
        format.js {}
      else
        format.html { redirect_to pro_business_profile_path(@business) }
        format.js {}
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @address.update(address_params)
        format.html { redirect_to pro_business_profile_path(@business) }
        format.js {}
      else
        format.html { render :edit }
        format.js {}
      end
    end
  end

  private

  def find_address
    @address = Address.find(params[:id])
    authorize @address
  end


  def address_params
    params.require(:address).permit(:day, :business_id, :start_time, :start_time_hour, :start_time_min, :end_time, :end_time_hour, :end_time_min, :street, :zipcode, :city, :active)
  end

end
