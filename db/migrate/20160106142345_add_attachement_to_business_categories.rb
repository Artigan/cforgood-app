class AddAttachementToBusinessCategories < ActiveRecord::Migration
  def self.up
    change_table :business_categories do |t|
      t.attachment :picture
    end
  end

  def self.down
    remove_attachment :business_categories, :picture
  end
end
