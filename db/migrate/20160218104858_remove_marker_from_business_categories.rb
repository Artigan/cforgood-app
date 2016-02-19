class RemoveMarkerFromBusinessCategories < ActiveRecord::Migration
  def change
    remove_column :business_categories, :marker_file_name
    remove_column :business_categories, :marker_content_type
    remove_column :business_categories, :marker_file_size
    remove_column :business_categories, :marker_updated_at
  end
end
