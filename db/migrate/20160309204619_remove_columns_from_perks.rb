class RemoveColumnsFromPerks < ActiveRecord::Migration
  def change
    remove_column :perks, :detail
    remove_column :perks, :periodicity_id
  end
end
