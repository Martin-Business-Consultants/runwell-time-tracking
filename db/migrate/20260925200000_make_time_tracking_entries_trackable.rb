class MakeTimeTrackingEntriesTrackable < ActiveRecord::Migration[8.1]
  def up
    add_reference :time_tracking_entries, :trackable, polymorphic: true
    add_reference :time_tracking_entries, :client, foreign_key: true
    change_column_null :time_tracking_entries, :engagement_id, true

    execute <<~SQL
      UPDATE time_tracking_entries SET trackable_type = 'Todo', trackable_id = todo_id WHERE todo_id IS NOT NULL
    SQL
    execute <<~SQL
      UPDATE time_tracking_entries SET trackable_type = 'Engagement', trackable_id = engagement_id WHERE todo_id IS NULL
    SQL
    execute <<~SQL
      UPDATE time_tracking_entries SET client_id = (SELECT client_id FROM engagements WHERE engagements.id = time_tracking_entries.engagement_id)
    SQL

    remove_reference :time_tracking_entries, :todo, foreign_key: true
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
