class AddNbDayToPartners < ActiveRecord::Migration[5.0]
  def change
    add_column :partners, :nb_days, :integer
    rename_column :partners, :nb_month, :nb_months
    rename_column :beneficiaries, :nb_month, :nb_months
  end
end
