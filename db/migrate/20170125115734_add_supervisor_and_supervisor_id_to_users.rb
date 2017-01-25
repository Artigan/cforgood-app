class AddSupervisorAndSupervisorIdToUsers < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :supervisor, :boolean, default: false
    add_reference :users, :supervisor, foreign_key: {to_table: :users}
  end

  def down
    remove_column :users, :supervisor
    remove_column :users, :supervisor_id
  end
end
