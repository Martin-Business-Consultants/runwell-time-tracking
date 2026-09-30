class CreateTimeTrackingEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :time_tracking_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.references :engagement, null: false, foreign_key: true
      t.references :todo, foreign_key: true
      t.datetime :started_at
      t.datetime :stopped_at
      t.integer :minutes
      t.date :worked_on, null: false
      t.string :note
      t.timestamps
    end
    add_index :time_tracking_entries, [ :user_id, :stopped_at ]
  end
end
