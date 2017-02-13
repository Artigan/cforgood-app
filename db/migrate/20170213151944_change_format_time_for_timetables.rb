class ChangeFormatTimeForTimetables < ActiveRecord::Migration[5.0]
  def up
    change_column :timetables, :day, 'integer USING CAST(day AS integer)'
    change_column :timetables, :start_at, :time
    change_column :timetables, :end_at, :time
  end

  def down
    change_column :timetables, :day, :string
    change_column :timetables, :start_at, :datetime
    change_column :timetables, :end_at, :datetime
  end
end
