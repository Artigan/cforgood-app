class RenameColumnTypeFromPeriodicities < ActiveRecord::Migration
  def change
    rename_column :periodicities, :type, :period
  end
end
