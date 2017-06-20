class AddLegalInfoForStripeToCauses < ActiveRecord::Migration[5.0]
  def change
    add_column :causes, :representative_birthday, :datetime
    add_column :causes, :acceptance_stripe, :boolean, default: false, null: false
    add_column :causes, :bank_account_id, :string
  end
end
