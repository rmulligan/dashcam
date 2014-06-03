module TripsHelper
  def in_pacific utc
    utc.in_time_zone('Pacific Time (US & Canada)').strftime("%a %b %d %Y - %I:%M %p %Z")
  end
end
