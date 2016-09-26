class CreateProspects < ActiveRecord::Migration
  def change
    create_table :prospects do |t|
      t.references :user, index: true, foreign_key: true
      t.string :name
      t.string :street
      t.string :zipcode
      t.string :city
      t.string :leader_name
      t.string :email
      t.boolean :canvassed, default: true, null: false
      t.timestamps null: false
    end
  end
end
