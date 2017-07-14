class AddLastSeenEcosystemToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :last_ecosystem_seen, :string
  end
end
