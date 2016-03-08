class JodelCityController < ApplicationController
  def index
    @jodel_cities = JodelCity.all
  end

  def self.update_cities
    handler = JodelHandler.new("8d84fcad-c3f0-4243-9c12-5b6c4ec86783")
    cities = JodelCity.all
    cities.each do |city|
      post = handler.loudest_post(city.latitude, city.longitude)
      city.update_attributes(loudest_jodel: post["message"], loudest_votes: post["vote_count"])
    end
  end

end
