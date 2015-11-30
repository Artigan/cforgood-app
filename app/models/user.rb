# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string
#  last_name              :string
#  provider               :string
#  uid                    :string
#  picture                :string
#  name                   :string
#  token                  :string
#  token_expiry           :datetime
#  admin                  :boolean          default(FALSE), not null
#  picture_file_name      :string
#  picture_content_type   :string
#  picture_file_size      :integer
#  picture_updated_at     :datetime
#  birthday               :datetime
#  nationality            :string
#  country_of_residence   :string
#  mangopay_id            :string
#  wallet_id              :string
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  has_one :cause


  def self.find_for_google_oauth2(access_token, signed_in_resourse=nil)
    data = access_token.info
    user = User.where(:provider => access_token.provider, :uid => access_token.uid).first

    if user
      return user
    else
    registred_user = User.where(:email => access_token.email).first
      if registred_user
        return registred_user
      else
        user = User.create(
          name: data['name'],
          provider: access_token.provider,
          email: data['email'],
          uid: access_token.uid,
          picture: data.image,
          password: Devise.friendly_token[0,20],
        )
      end
    end
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resourse=nil)
    data = access_token.info
    user = User.where(:provider => access_token.provider, :uid => access_token.uid).first

    if user
      return user
    else
    registred_user = User.where(:email => data.email).first
      if registred_user
        return registred_user
      else
        user = User.create(
          name: access_token.extra.raw_info.name,
          provider: access_token.provider,
          email: data.email,
          uid: access_token.uid,
          picture: data.image,
          password: Devise.friendly_token[0,20],
        )
      end
    end
  end

  def self.process_uri(uri)
    require 'open-uri'
    require 'open_uri_redirections'
    open(uri, :allow_redirections => :safe) do |r|
      r.base_uri.to_s
    end
  end

  def create_mangopay_user!
    user_info = {
      "FirstName": self.first_name,
      "LastName": self.last_name,
      "Birthday": self.birthday.to_i,
      "Nationality": self.nationality,
      "CountryOfResidence": "FR",
      "PersonType": "NATURAL",
      "Email": self.email
    }

    mangopay_user = MangoPay::NaturalUser.create(user_info)

    # begin
      self.update(mangopay_id: mangopay_user["Id"])
    # rescue => e
    #   Rails.logger.info(e)
    # end
  end

  def create_mangopay_wallet!
    wallet_info = {
      Owners: [self.mangopay_id],
      Description: "Portefeuille de #{self.first_name} #{self.last_name}",
      Currency: 'EUR'
    }

    mangopay_wallet = MangoPay::Wallet.create(wallet_info)

    self.update(wallet_id: mangopay_wallet["Id"])
  end

  def create_mangopay_payin!
    payin_info = {
      AuthorId: self.mangopay_id,
      DebitedWalletId: self.wallet_id,
      CreditedUserId: "9697271",
      CreditedWalletId: "9697447",
      DebitedFunds: { Currency: 'EUR', Amount: 250 },
      Fees: { Currency: 'EUR', Amount: 250 },
      CreditedWalletId: wallet_id,
      ReturnURL: 'https://your.company.com',
      CardType: 'CB_VISA_MASTERCARD',
      Culture: 'FR',
      Tag: 'Test Card'
    }

    mangopay_payin=MangoPay::PayIn::Card::Web.create(payin_info)
  end
end
