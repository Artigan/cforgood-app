class CreateEcosystems < ActiveRecord::Migration[5.0]
  def change
    create_table :ecosystems do |t|
      t.string :name
      t.string :city
      t.string :zipcode
      t.integer :radius
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
