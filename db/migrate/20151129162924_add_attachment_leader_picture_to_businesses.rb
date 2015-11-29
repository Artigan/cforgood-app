class AddAttachmentLeaderPictureToBusinesses < ActiveRecord::Migration
  def self.up
    change_table :businesses do |t|
      t.attachment :leader_picture
    end
  end

  def self.down
    remove_attachment :businesses, :leader_picture
  end
end
