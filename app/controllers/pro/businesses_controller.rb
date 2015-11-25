class Pro::BusinessesController < ApplicationController

  layout 'pro'

  before_action :authenticate_business!
  before_action :find_business, only: [:show, :edit, :update]

  def show
    @perks = @business.perks
  end

  def edit
  end

  def update
    if @business.update(business_params)
      redirect_to pro_business_path(@business)
    else
     render :edit
    end
  end

  private

  def find_business
    @business = Business.find(params[:id])
  end

end
