class AddBooleanForcedGeolocToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :forced_geoloc, :boolean, default: false, null: false
  end
end
