class CreatePlans < ActiveRecord::Migration[5.0]
  def change
    create_table :plans do |t|
      t.references :user, foreign_key: true
      t.string :subscription
      t.integer :amount
      t.string :code_partner
      t.date :date_end_partner

      t.timestamps
    end
  end
end
