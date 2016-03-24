class Pro::AddressesController < ApplicationController

  before_action :find_business, only: [:index, :new, :create]

  def index
    @addresses = policy_scope(Address)
  end

  def new
    @address = Address.new
    authorize @address
  end

  def create
    @address = @business.adresses.build(address_params)
    authorize @address

    respond_to do |format|
      if @address.save
        format.html { redirect_to pro_business_addresses_path(@business) }
        format.js {}
      else
        format.html { render :new }
        format.js {}
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @address.update(address_params)
        format.html { redirect_to pro_business_addresses_path(current_business) }
        format.js {}
      else
        format.html { render :edit }
        format.js {}
      end
    end
  end

  def destroy
    @address.destroy
    redirect_to pro_business_addresses_path(current_business)
  end

  private

  def find_address
    @address = Address.find(params[:id])
    authorize @address
  end

  def find_business
    @business = Business.find(params[:business_id])
  end

  def address_params
    params.require(:address).permit(:day, :business_id, :street, :zipcode, :city, :active)
  end

end
