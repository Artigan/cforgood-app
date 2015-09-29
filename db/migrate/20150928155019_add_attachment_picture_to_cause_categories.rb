class AddAttachmentPictureToCauseCategories < ActiveRecord::Migration
  def self.up
    change_table :cause_categories do |t|
      t.attachment :picture
    end
  end

  def self.down
    remove_attachment :cause_categories, :picture
  end
end
