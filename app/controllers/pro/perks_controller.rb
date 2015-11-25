class Pro::PerksController < ApplicationController

layout 'pro'

before_action :find_perk, only: [:edit, :update]
before_action :find_business, only: [:new, :create]

  def index
    @perks = current_business.perks
  end

  def new
    @perk = Perk.new
  end

  def create
    @perk = @business.perks.build(perk_params)
    if @perk.save
      redirect_to pro_business_perks_path(@business)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @perk.update(perk_params)
      redirect_to pro_business_perks_path(@business)
    else
     render :edit
    end
  end

  private

  def find_perk
     @perk = Perk.find(params[:id])
  end

  def find_business
    @business = Business.find(params[:business_id])
  end

  def perk_params
    params.require(:perk).permit()
  end
end
