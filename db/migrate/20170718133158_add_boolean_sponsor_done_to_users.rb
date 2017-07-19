class AddBooleanSponsorDoneToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :sponsorship_done, :boolean, default: false, null: false
  end
end
