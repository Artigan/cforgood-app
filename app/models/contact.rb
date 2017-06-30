# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  users_id   :integer
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
#  index_contacts_on_users_id  (users_id)
#
# Foreign Keys
#
#  fk_rails_de1d4dcf7d  (users_id => users.id)
#

class Contact < ApplicationRecord
  belongs_to :users
end
