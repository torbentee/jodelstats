class JodelCityController < ApplicationController
  def index
    @jodel_cities = JodelCity.all.order(highest_votes: :desc)
  end

  def show
    @city = JodelCity.find_by(name: params[:city_name])
  end

  def self.update_cities
    handler = JodelHandler.new("08b4d4e7-43b6-4916-8974-50d75939a2f5")
    cities = JodelCity.all
    cities.each do |city|
      city.jodel_posts.destroy_all
      response = handler.get_posts(city.latitude, city.longitude)
      top_posts = response["voted"]
      if !top_posts.nil? && !top_posts.empty?
        city.update_attributes(highest_votes: top_posts[0]["vote_count"])
      end
      top_posts.each do |post|
        city.jodel_posts.create(post_id: post["id"], created_at: post["created_at"],
              updated_at: post["updated_at"], message: post["message"],
              vote_count: post["vote_count"], color: post["color"],
              image_url: post["image_url"], thumbnail_url: post["thumbnail_url"])
      end
    end
  end

end
