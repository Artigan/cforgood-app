class AddActivityToBusinesses < ActiveRecord::Migration[5.0]
  def change
    add_column :businesses, :activity, :string
  end
end
