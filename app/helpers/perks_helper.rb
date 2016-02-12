# == Schema Information
#
# Table name: perks
#
#  id                   :integer          not null, primary key
#  perk                 :string
#  business_id          :integer
#  description          :text
#  detail               :string
#  periodicity_id       :integer
#  times                :integer          default(0)
#  start_date           :datetime
#  end_date             :datetime
#  permanent            :boolean          default(TRUE), not null
#  active               :boolean          default(TRUE), not null
#  perk_code            :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  nb_views             :integer          default(0)
#  appel                :boolean          default(FALSE), not null
#  durable              :boolean          default(FALSE), not null
#  flash                :boolean          default(FALSE), not null
#  picture_file_name    :string
#  picture_content_type :string
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#
# Indexes
#
#  index_perks_on_business_id     (business_id)
#  index_perks_on_periodicity_id  (periodicity_id)
#
# Foreign Keys
#
#  fk_rails_369c0ee5d8  (periodicity_id => periodicities.id)
#  fk_rails_5797f2b98a  (business_id => businesses.id)
#

module PerksHelper
end
