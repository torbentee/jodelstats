class JodelCityController < ApplicationController
  def index
    @jodel_cities = JodelCity.all.order(highest_votes: :desc)
  end

  def show
    @city = JodelCity.find_by(name: params[:city_name])
  end

  def self.update_cities
    @api_key ||= ApiKey.first.token
    handler = JodelHandler.new(@api_key)

    if ApiKey.first.expiration_date < 1.hour.from_now
      self.update_api_token
    end

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

  def self.update_api_token
    current_client_id = "hMVuaJY/usV28y/CoGTs+of/MEmWah2ewWCa1zJB3aA="
    distinct_id = "564ad8129798003757f499b0"
    refresh_token = "1bb76acc-b323-4ac1-a689-0101a31287df"

    handler = JodelHandler.new(ApiKey.first.token)
    handler.refresh_token(current_client_id, distinct_id, refresh_token)
  end

end
