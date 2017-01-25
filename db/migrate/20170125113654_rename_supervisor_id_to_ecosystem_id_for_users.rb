class RenameSupervisorIdToEcosystemIdForUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :supervisor_id, :ecosystem_id
  end
end
