# Time is logged as minutes; there are no live timers.
class RemoveTimersFromTimeTrackingEntries < ActiveRecord::Migration[8.1]
  def change
    remove_index :time_tracking_entries, %i[user_id stopped_at]
    remove_column :time_tracking_entries, :started_at, :datetime
    remove_column :time_tracking_entries, :stopped_at, :datetime
    change_column_null :time_tracking_entries, :minutes, false
  end
end
