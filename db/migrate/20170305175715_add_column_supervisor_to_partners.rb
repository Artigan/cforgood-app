class AddColumnSupervisorToPartners < ActiveRecord::Migration[5.0]
  def change
    add_reference :partners, :supervisor, index: true, foreign_key: {to_table: :businesses}
    add_reference :causes, :supervisor, index: true, foreign_key: {to_table: :businesses}
  end
end
