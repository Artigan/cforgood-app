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
#  unused     :boolean          default(FALSE)
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

class Use < ApplicationRecord
  belongs_to :user
  belongs_to :perk

  after_create :event_intercom_create
  after_save :event_intercom_unlike, if: :unlike_changed?

  scope :without_feedback, -> { where(feedback: false) }

  # feedback == false : perk/use est considéré comme utilisé tant que feedback non saisi
  # feedback == true && unused = false : perk/use est considéré comme utilisé car il est donc soit liked soit unliked
  scope :used, -> { where(feedback: true, unused: false).or(where(feedback: false)) }
  scope :liked, -> { where(like: true) }

  scope :used_by_users_for, -> (user) { used.includes(:user).where(user: user.users) }
  scope :liked_by_users_for, -> (user) { liked.includes(:user).where(user: user.users) }

  def event_intercom_firstperk
    send_event_intercom("use_firstperk_cforgood")
  end

  private

  def event_intercom_create
    send_event_intercom("use_perk")
  end

  def event_intercom_unlike
    send_event_intercom("unlike_perk") if self.unlike
  end

  def send_event_intercom(event_name)
    @user = User.find(user_id)
    @perk = Perk.find(perk_id)
    intercom = Intercom::Client.new(app_id: ENV['INTERCOM_API_ID'], api_key: ENV['INTERCOM_API_KEY'])
    begin
      intercom.events.create(
        event_name: event_name,
        created_at: Time.now.to_i,
        user_id: @user.id,
        email: @user.email,
        metadata: {
          business_name: @perk.business.name,
          business_category: @perk.business_category.name,
          perk_name: @perk.name
        }
      )
    rescue Intercom::IntercomError => e
      puts e
    end
  end
end
