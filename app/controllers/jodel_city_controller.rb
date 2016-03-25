class JodelCityController < ApplicationController
  def index
    @jodel_cities = JodelCity.where(country: params[:country_name]).order(highest_votes: :desc)
  end

  def show
    @city = JodelCity.find_by(name: params[:city_name])
  end

  def new
    @city = JodelCity.new
  end

  def create
    unless @city = JodelCity.where("lower(name) = ?", params[:city][:name].downcase).first
      @gHandler ||= GoogleHandler.new
      @city = JodelCity.create(@gHandler.coordinates_for(params[:city][:name]))
      @api_key ||= ApiKey.first.token
      handler = JodelHandler.new(@api_key)
      JodelCityController.update_city(@city, handler)
    end
    redirect_to "/cities/#{@city.name}"
  end

  def self.update_cities
    @api_key ||= ApiKey.first.token
    handler = JodelHandler.new(@api_key)

    if ApiKey.first.expiration_date < 1.hour.from_now
      self.update_api_token
    end

    cities = JodelCity.all
    cities.each do |city|
      if city.country == nil
        city.destroy
      else
        self.update_city(city, handler)
      end
    end
  end

  def self.update_city(city, handler)
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

  def self.update_api_token
    api_key = ApiKey.first
    current_client_id = api_key.current_client_id
    distinct_id = api_key.distinct_id
    refresh_token = api_key.refresh_token

    handler = JodelHandler.new(api_key.token)
    handler.refresh_token(current_client_id, distinct_id, refresh_token)
  end

end
