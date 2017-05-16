class AddNationalBooleanToCauses < ActiveRecord::Migration[5.0]
  def change
    add_column :causes, :national, :boolean, default: false
  end
end
