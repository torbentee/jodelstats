class JodelCityController < ApplicationController
  def index
    @jodel_cities = JodelCity.all
  end

  def self.update_cities
    handler = JodelHandler.new("a44549e5-8f61-4db7-acbf-d9c4673f53ff")
    cities = JodelCity.all
    cities.each do |city|
      city.jodel_posts.delete_all
      response = handler.get_posts(city.latitude, city.longitude)
      top_posts = response["voted"]
      top_posts.each do |post|
        city.jodel_posts.create(post_id: post["id"], created_at: post["created_at"],
              updated_at: post["updated_at"], message: post["message"],
              vote_count: post["vote_count"], color: post["color"],
              image_url: post["image_url"], thumbnail_url: post["thumbnail_url"])
      end
    end
  end

end
