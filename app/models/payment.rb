# == Schema Information
#
# Table name: payments
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  cause_id   :integer
#  amount     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  done       :boolean          default(FALSE), not null
#
# Indexes
#
#  index_payments_on_cause_id  (cause_id)
#  index_payments_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_081dc04a02  (user_id => users.id)
#  fk_rails_de053cb0c6  (cause_id => causes.id)
#

class Payment < ActiveRecord::Base
  belongs_to :user
  belongs_to :cause

  validates :user_id, presence: true
  validates :cause_id, presence: true
  validates :amount, presence: true

  after_create :create_event_intercom

  private

  def create_event_intercom
    @user = User.find(user_id)
    if @user.payments.count <= 1
      intercom = Intercom::Client.new(app_id: ENV['INTERCOM_API_ID'], api_key: ENV['INTERCOM_API_KEY'])
      begin
        intercom.events.create(
          event_name: "first-payment",
          created_at: Time.now.to_i,
          user_id: @user.id,
          email: @user.email,
          metadata: {
            amount:  @user.amount,
            cause_id: @user.cause.name
          }
        )
      rescue Intercom::ResourceNotFound
      end
    end
  end
end
