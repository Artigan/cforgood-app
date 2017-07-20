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
#  phone  :string
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

  before_create :send_sms

  private

  def send_sms
    client = Octopush::Client.new
    # first needs to create a sms instance
    sms = Octopush::SMS.new
    # set your desired attributes
    sms.sms_text = 'Dis, tu connais CforGood ? L’app pour consommer local et responsable. Il y a plein de bonnes adresses et de réductions exclusives ! Profites en gratuitement avec mon code : '
    sms.sms_text += "GOODSPONSOR" + user_id.to_s + ". "
    sms.sms_text += 'https://r53r.app.link'
    sms.sms_recipients = phone
    sms.sms_type = 'FR'
    sms.sms_sender = 'CforGood'
    sms.transactional = '1'
    # then just send the sms with the client you created before
    begin
      client.send_sms(sms)
    rescue Exception => e
      puts e
      errors.add(:phone, "Erreur envoi sms : #{e}")
      raise ActiveRecord::Rollback
    end
    send = true
  end

end
