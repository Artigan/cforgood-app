class CreatePeriodicities < ActiveRecord::Migration
  def change
    create_table :periodicities do |t|
      t.string :type

      t.timestamps null: false
    end
  end
end
