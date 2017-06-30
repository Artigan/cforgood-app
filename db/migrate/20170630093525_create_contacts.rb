class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.references :users, foreign_key: true
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :city
      t.string :telephone
      t.boolean :used, default: false, null: false

      t.timestamps
    end
  end
end
