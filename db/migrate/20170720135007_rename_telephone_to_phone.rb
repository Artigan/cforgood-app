class RenameTelephoneToPhone < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :telephone, :phone
    rename_column :causes, :telephone, :phone
    rename_column :businesses, :telephone, :phone
    rename_column :contacts, :telephone, :phone
  end
end
