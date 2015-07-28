class AddAttachmentPictureToCauses < ActiveRecord::Migration
  def self.up
    change_table :causes do |t|
      t.attachment :picture
    end
  end

  def self.down
    remove_attachment :causes, :picture
  end
end
