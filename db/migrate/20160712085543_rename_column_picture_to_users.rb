class RenameColumnPictureToUsers < ActiveRecord::Migration
  def change
    rename_column :users, :picture, :picture_cloud
  end
end
