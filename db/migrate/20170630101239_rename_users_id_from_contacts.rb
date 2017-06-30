class RenameUsersIdFromContacts < ActiveRecord::Migration[5.0]
  def change
    rename_column :contacts, :users_id, :user_id
  end
end
