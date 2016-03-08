class ChangeColumnsPerks < ActiveRecord::Migration
  def change
    rename_column :perks, :perk, :name
    add_reference :perks, :pperk_detail, index: true
  end
end
