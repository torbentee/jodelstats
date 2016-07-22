require 'rufus-scheduler'

scheduler = Rufus::Scheduler.singleton

if ENV["jodelstats_update"] == 'enabled'
  puts "JODEL UPDATE ON"
  scheduler.every(ENV["jodelstats_refresh_interval"] || "5m") do
    JodelCityController.update_cities
  end
else
  puts "JODEL UPDATE OFF"
end
