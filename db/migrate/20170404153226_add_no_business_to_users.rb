class AddNoBusinessToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :nothing_around, :integer
  end
end
