require 'rufus-scheduler'

scheduler = Rufus::Scheduler.singleton

if ENV["jodelstats_update"]
  puts "JODEL UPDATE ON"
  scheduler.every("5m") do
    JodelCityController.update_cities
  end
else
  puts "JODEL UPDATE OFF"
end
