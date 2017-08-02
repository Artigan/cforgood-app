class AddBoundingBoxToEcosystems < ActiveRecord::Migration[5.0]
  def change
    add_column :ecosystems, :min_longitude, :float
    add_column :ecosystems, :min_latitude , :float
    add_column :ecosystems, :max_longitude, :float
    add_column :ecosystems, :max_latitude , :float
  end
end
