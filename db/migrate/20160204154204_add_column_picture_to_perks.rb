class AddColumnPictureToPerks < ActiveRecord::Migration
 def self.up
    change_table :perks do |t|
      t.attachment :picture
    end
  end

  def self.down
    remove_attachment :perks, :picture
  end
end
