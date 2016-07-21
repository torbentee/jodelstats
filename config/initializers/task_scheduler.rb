require 'rufus-scheduler'

scheduler = Rufus::Scheduler.singleton

if ENV["jodelstats_update"]
  scheduler.every("5m") do
    JodelCityController.update_cities
  end
end
