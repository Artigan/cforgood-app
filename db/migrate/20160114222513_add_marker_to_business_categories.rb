class AddMarkerToBusinessCategories < ActiveRecord::Migration
  def self.up
    change_table :business_categories do |t|
      t.attachment :marker
    end
  end

  def self.down
    remove_attachment :business_categories, :marker
  end
end
