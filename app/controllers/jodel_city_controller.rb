class JodelCityController < ApplicationController
  def index
    @jodel_cities = JodelCity.all
  end

  def self.update_cities
    handler = JodelHandler.new("a44549e5-8f61-4db7-acbf-d9c4673f53ff")
    cities = JodelCity.all
    cities.each do |city|
      post = handler.loudest_post(city.latitude, city.longitude)
      city.update_attributes(loudest_jodel: post["message"], loudest_votes: post["vote_count"])
    end
  end

end
