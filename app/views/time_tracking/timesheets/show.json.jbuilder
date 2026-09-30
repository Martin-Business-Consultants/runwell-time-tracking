json.summary "#{duration @entries.sum(&:minutes)} #{@week} week (#{@person == "me" ? "yours" : "everyone"})"
json.week_of @days.first
json.days(@days.map { |day| entries = @entries.select { it.worked_on == day }; { date: day, total: duration(entries.sum(&:minutes)), minutes: entries.sum(&:minutes) } })
json.entries @entries do |entry|
  json.extract! entry, :id, :minutes, :worked_on, :note
  json.duration duration(entry.minutes)
  json.on agent_ref(entry.trackable)
  json.person agent_user(entry.user)
end
