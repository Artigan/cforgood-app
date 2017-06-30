# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  email      :string
#  first_name :string
#  last_name  :string
#  city       :string
#  telephone  :string
#  used       :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_contacts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_de1d4dcf7d  (user_id => users.id)
#

class Contact < ApplicationRecord
  belongs_to :users, class_name: 'User', foreign_key: 'user_id'

  validates :email, presence: true, uniqueness: true
end
