class UsesController < ApplicationController

  def create
    @use = current_user.uses.new(perk_id: params[:perk_id])
    # check if code exists
    respond_to do |format|
      # if exist @exist = true
      if @use.save
        format.html { redirect_to pro_business_perks_path(@business) }
        format.js {}
      else
        format.html { render :new }
        format.js {}
      end
      # else

    end
    # redirect_to member_card_path
  end
end

