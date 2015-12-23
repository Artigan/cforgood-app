class MangopayServices

  def initialize(current_user)
      @user = current_user
  end

  def create_mangopay_natural_user
    user_info = {
      "FirstName": @user.first_name,
      "LastName": @user.last_name,
      "Birthday": @user.birthday.to_i,
      "Nationality": "FR",
      # "Nationality": self.nationality,
      "CountryOfResidence": "FR",
      "PersonType": "NATURAL",
      "Email": @user.email
    }
    mangopay_natural_user_create(user_info)
  end

  def create_mangopay_card_pre_registration
    card_registration_info = {
      UserId: @user.mangopay_id,
      Currency: "EUR",
      CardType: "CB_VISA_MASTERCARD"
    }

    mangopay_card_registration_create(card_registration_info)
  end

  def create_mangopay_payin(wallet_id)
    amount = 500 if @user.subscription == "M"
    amount = 5000 if @user.subscription == "A"

    payin_info = {
      AuthorId: @user.mangopay_id,
      DebitedFunds: { Currency: 'EUR', Amount: amount },
      CreditedFunds: { Currency: 'EUR', Amount: amount/2 },
      Fees: { Currency: 'EUR', Amount: amount/2 },
      CreditedWalletId: wallet_id,
      CardId: @user.card_id,
      SecureMode:"DEFAULT",
      SecureModeReturnURL:"https://www.cforgood.com"
    }

    mangopay_payin_card_direct(payin_info)
  end


  def create_mangopay_legal_user
    legal_user_info = {
      Name: current_cause.name,
      Email: current_cause.email,
      LegalPersonType: "BUSINESS",
      LegalRepresentativeFirstName: current_cause.representative_first_name,
      LegalRepresentativeLastName: current_cause.representative_last_name,
      LegalRepresentativeBirthday: 0,
      LegalRepresentativeNationality: 'FR',
      LegalRepresentativeCountryOfResidence: 'FR'
    }

    mangopay_legal_user_create(legal_user_info)
  end

  def create_mangopay_wallet
    wallet_info = {
      Owners: [current_cause.mangopay_id],
      Description: "Portefeuille de #{current_cause.name}",
      Currency: 'EUR'
    }

    mangopay_wallet_create(wallet_info)
  end

  private

  def mangopay_natural_user_create(user_info)
    MangoPay::NaturalUser.create(user_info)
  end

  def mangopay_card_registration_create(card_registration_info)
    MangoPay::CardRegistration.create(card_registration_info)
  end

  def mangopay_payin_card_direct(payin_info)
    MangoPay::PayIn::Card::Direct.create(payin_info)
  end

  def mangopay_legal_user_create(legal_user_info)
    MangoPay::LegalUser.create(legal_user_info)
  end

  def mangopay_wallet_create(wallet_info)
    MangoPay::Wallet.create(wallet_info)
  end
end

