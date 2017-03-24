class AddBusinessSupervisorToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :business_supervisor, index: true, foreign_key: {to_table: :businesses}
  end
end
