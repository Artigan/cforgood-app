class RemoveColumnPerkFromBusinesses < ActiveRecord::Migration
  def change
    remove_column :businesses, :perk, :string
    remove_column :businesses, :descripton_perk, :string
    remove_column :businesses, :detail_perk, :string
    remove_column :businesses, :description2_perk, :string
  end
end
