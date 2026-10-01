module TimeTracking
  # A Runwell plugin: it owns its tables, points at core records by id, and extends the core
  # only through Runwell::Plugins, model load hooks and "event.runwell". The core never
  # refers to it; remove the gem and the app runs as before.
  class Engine < ::Rails::Engine

    # Routes join the app's own route set (as time_tracking_*), so the core layout's helpers
    # work on the plugin's pages.
    initializer "time_tracking.routes" do |app|
      app.routes.append do
        scope "time", module: "time_tracking", as: "time_tracking" do
          resource :timesheet, only: :show
          resources :entries, only: %i[create destroy]
        end
      end
    end

    initializer "time_tracking.helpers" do
      ActiveSupport.on_load(:action_view) { include TimeTracking::DurationHelper }
    end

    initializer "time_tracking.models" do
      ActiveSupport.on_load(:runwell_todo) { has_many :time_entries, class_name: "TimeTracking::Entry", as: :trackable, dependent: :destroy }
      ActiveSupport.on_load(:runwell_engagement) { has_many :time_entries, class_name: "TimeTracking::Entry", dependent: :destroy }
      ActiveSupport.on_load(:runwell_client) { has_many :time_entries, class_name: "TimeTracking::Entry", dependent: :destroy }
      ActiveSupport.on_load(:runwell_user) { has_many :time_entries, class_name: "TimeTracking::Entry", dependent: :destroy }
    end

    config.to_prepare do
      Runwell::Plugins.register :time_tracking, name: "Time tracking", version: TimeTracking::VERSION, author: "Runwell",
        enabled_by_default: false, requires: ">= 2.1.0", homepage: "https://github.com/Martin-Business-Consultants/runwell-time-tracking",
        description: "Log time on clients, engagements and work, with totals and a weekly timesheet. Keeps its own table and reads core records by id."
      Runwell::Plugins.slot :todo_panel, :time_tracking, "time_tracking/slots/todo_panel"
      Runwell::Plugins.slot :engagement_panel, :time_tracking, "time_tracking/slots/engagement_panel"
      Runwell::Plugins.slot :client_panel, :time_tracking, "time_tracking/slots/client_panel"
      Runwell::Plugins.permission :time_tracking, :view_everyones_time, name: "See everyone’s time", roles: %w[owner manager]
      Runwell::Plugins.quick_action :time_tracking, label: "Log time", title: "Log time", icon: "history", partial: "time_tracking/quick_actions/time",
        types: TimeTracking::Entry::TRACKABLE_TYPES, context: ->(record) { TimeTracking::Entry.trackable_for(record) }
    end
  end
end
