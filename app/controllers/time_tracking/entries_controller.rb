module TimeTracking
  class EntriesController < ApplicationController
    allow_staff
    agent_tool :log_time, on: :create, title: "Log time",
      description: "record: \"Type:id\" for a Client, Engagement or Todo (a scope item goes to its engagement, a request to its client). duration like 1:30, 90 or 1.5h.",
      params: { record: "string", entry: { duration: "string!", worked_on: "date", note: "string" } }
    agent_tool :delete_time, on: :destroy, title: "Delete time you logged"

    def create
      entry = Entry.new(user: Current.user, trackable: find_trackable, minutes: Entry.minutes_from(params.dig(:entry, :duration)),
        worked_on: params.dig(:entry, :worked_on).presence, note: params.dig(:entry, :note).presence)
      if entry.save
        redirect_back fallback_location: time_tracking_timesheet_path, notice: "#{helpers.duration(entry.minutes)} logged."
      else
        redirect_back fallback_location: time_tracking_timesheet_path, alert: "Enter a duration like 1:30, 90 or 1.5h."
      end
    end

    def destroy
      Current.user.time_entries.find(params[:id]).destroy!
      redirect_back fallback_location: root_path, notice: "Time removed."
    end

    private
      # The record picked in the quick action tray ("Client:12"), or none.
      def find_trackable
        Entry.trackable_for(QuickAction.locate(params[:record], QuickAction::RECORD_TYPES)) if params[:record].present?
      end
  end
end
