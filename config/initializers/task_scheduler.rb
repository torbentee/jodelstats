require 'rufus-scheduler'

scheduler = Rufus::Scheduler.singleton

scheduler.every("5m") do
  JodelCityController.update_cities
end
