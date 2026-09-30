module TimeTracking
  module DurationHelper
    def duration(minutes)
      hours, mins = minutes.to_i.divmod(60)
      [ ("#{hours}h" if hours.positive?), ("#{mins}m" if mins.positive? || hours.zero?) ].compact.join(" ")
    end

    def time_entry_path(entry)
      entry.trackable ? search_result_path(entry.trackable) : time_tracking_timesheet_path
    end
  end
end
