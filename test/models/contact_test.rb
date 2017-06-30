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

require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
