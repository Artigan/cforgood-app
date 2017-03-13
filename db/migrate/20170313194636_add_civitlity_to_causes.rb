class AddCivitlityToCauses < ActiveRecord::Migration[5.0]
  def change
    add_column :causes, :civility, :integer
  end
end
