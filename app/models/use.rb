# == Schema Information
#
# Table name: uses
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  perk_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  feedback   :boolean          default(FALSE)
#  like       :boolean          default(FALSE)
#  unlike     :boolean          default(FALSE)
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

class Use < ActiveRecord::Base
  belongs_to :user
  belongs_to :perk

  after_create :create_event_intercom

  scope :without_feedback, -> { where(feedback: false) }
  scope :used, -> { where('feedback = ? or (feedback = ? and unused = ?)', false, true, false) }

  private

  def create_event_intercom
    @user = User.find(user_id)
    @perk = Perk.find(perk_id)
    intercom = Intercom::Client.new(app_id: ENV['INTERCOM_API_ID'], api_key: ENV['INTERCOM_API_KEY'])
    begin
      intercom.events.create(
        event_name: "use-perk",
        created_at: Time.now.to_i,
        user_id: @user.id,
        email: @user.email,
        metadata: {
          business_name: @perk.business.name,
          perk_name: @perk.name
        }
      )
    rescue Intercom::IntercomError => e
    end
  end
end
