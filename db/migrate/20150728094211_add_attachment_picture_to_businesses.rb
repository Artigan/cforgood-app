class AddAttachmentPictureToBusinesses < ActiveRecord::Migration
  def self.up
    change_table :businesses do |t|
      t.attachment :picture
    end
  end

  def self.down
    remove_attachment :businesses, :picture
  end
end
