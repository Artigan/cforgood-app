class RenameUsedToSendContacts < ActiveRecord::Migration[5.0]
  def change
    rename_column :contacts, :used, :sms_sent
  end
end
