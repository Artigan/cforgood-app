class UsesController < ApplicationController

  def create
    @use = current_user.uses.new(perk_id: params[:perk_id])
    @use.save
    redirect_to @use.perk.business.url
  end

end

