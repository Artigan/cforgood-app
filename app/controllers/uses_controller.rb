class UsesController < ApplicationController

  def create
    @use = current_user.uses.new(perk_id: params[:perk_id])
    @use.save
    redirect_to member_card_path
  end
end

