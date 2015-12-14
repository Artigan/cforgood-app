# == Schema Information
#
# Table name: causes
#
#  id                   :integer          not null, primary key
#  name                 :string
#  description          :string
#  street               :string
#  zipcode              :string
#  city                 :string
#  url                  :string
#  email                :string
#  telephone            :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  impact               :string
#  picture_file_name    :string
#  picture_content_type :string
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#  cause_category_id    :integer
#  facebook             :string
#  twitter              :string
#  instagram            :string
#  description_impact   :string
#  latitude             :float
#  longitude            :float
#  mangopay_id          :string
#  wallet_id            :string
#  legal_first_name     :string
#  legal_last_name      :string
#
# Indexes
#
#  index_causes_on_cause_category_id  (cause_category_id)
#

class Cause < ActiveRecord::Base
  belongs_to   :cause_category
  belongs_to   :user

  has_attached_file :picture,
      styles: { medium: "300x300>", small: "200x200", thumb: "100x100>" }

    validates_attachment_content_type :picture,
      content_type: /\Aimage\/.*\z/

  def create_mangopay_legal_user!
    legal_user_info = {
      Name: self.name,
      Email: self.email,
      LegalPersonType: "BUSINESS",
      LegalRepresentativeFirstName: self.first_name,
      LegalRepresentativeLastName: self.last_name,
      LegalRepresentativeBirthday: 0,
      LegalRepresentativeNationality: 'FR',
      LegalRepresentativeCountryOfResidence: 'FR'
      }

    mangopay_legal_user = MangoPay::LegalUser.create(legal_user_info)

    self.update(mangopay_id: mangopay_legal_user["Id"])
  end

  def create_mangopay_wallet!
    wallet_info = {
      Owners: [self.mangopay_id],
      Description: "Portefeuille de #{self.name}",
      Currency: 'EUR'
    }

    mangopay_wallet = MangoPay::Wallet.create(wallet_info)

    self.update(wallet_id: mangopay_wallet["Id"])
  end
end

