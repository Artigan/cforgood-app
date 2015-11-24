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

class Use < ActiveRecord::Base
  belongs_to :user
  belongs_to :perk
end
