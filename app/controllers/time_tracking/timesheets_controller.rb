module TimeTracking
  class TimesheetsController < ApplicationController
    allow_staff
    agent_tool :show_timesheet, on: :show, title: "Show a weekly timesheet", params: { week: %w[this last], person: %w[me everyone] }

    def show
      @week = params[:week].presence_in(%w[this last]) || "this"
      @person = params[:person].presence_in(%w[me everyone]) || "me"
      @person = "me" unless can?(:view_everyones_time)

      start = Date.current.beginning_of_week - (@week == "last" ? 7 : 0)
      @days = (start..start + 6)
      scope = Entry.where(worked_on: @days).preload(:user, :trackable, :engagement, :client)
      scope = scope.where(user: Current.user) if @person == "me"
      @entries = scope.order(:worked_on, :created_at)
    end
  end
end
