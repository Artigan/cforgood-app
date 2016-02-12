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

  def create
    @use = current_user.uses.new(perk_id: params[:perk_id])
    @use.save
    redirect_to member_card_path
  end
end

