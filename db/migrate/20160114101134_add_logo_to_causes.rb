class AddLogoToCauses < ActiveRecord::Migration
  def self.up
    change_table :causes do |t|
      t.attachment :logo
    end
  end

  def self.down
    remove_attachment :causes, :logo
  end
end
