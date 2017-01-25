class AddSupervisorAndSupervisorIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :supervisor, :boolean
    add_reference :users, :supervisor, foreign_key: {to_table: :users} 
  end
end
