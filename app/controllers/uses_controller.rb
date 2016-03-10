# == Schema Information
#
# Table name: uses
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  perk_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_uses_on_perk_id  (perk_id)
#  index_uses_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_7057e30f7a  (perk_id => perks.id)
#  fk_rails_b60db94a9d  (user_id => users.id)
#

class UsesController < ApplicationController

  before_action :find_perk

  def create
    @use = current_user.uses.new(perk_id: params[:perk_id])
    # Control perk_code exist
    if Perk.find(params[:perk_id]).perk_code == params[:code][:perk_code].squish.upcase
      @perk_exist = true
    else
      @perk_exist = false
    end
    respond_to do |format|
      if @perk_exist
        if @use.save
          format.html { redirect_to business_path(@perk.business_id, perk_id: @perk.id ) }
          format.js {}
        else
          format.html { render :new }
          format.js {}
        end
      else
        format.html { render :new }
        format.js {}
      end
    end
  end

  private

  def find_perk
    @perk = Perk.find(params[:perk_id])
  end

end

