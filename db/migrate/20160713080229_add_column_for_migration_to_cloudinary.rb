class AddColumnForMigrationToCloudinary < ActiveRecord::Migration
  def change
    add_column :businesses, :picture_cloud, :string
    add_column :businesses, :leader_picture_cloud, :string
    add_column :businesses, :logo_cloud, :string
    add_column :business_categories, :picture_cloud, :string
    add_column :causes, :picture_cloud, :string
    add_column :causes, :logo_cloud, :string
    add_column :cause_categories, :picture_cloud, :string
    add_column :perks, :picture_cloud, :string
  end
end
