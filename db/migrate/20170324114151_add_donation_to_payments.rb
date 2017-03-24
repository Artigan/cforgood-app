class AddDonationToPayments < ActiveRecord::Migration[5.0]
  def change
    add_column :payments, :donation, :float
  end
end
