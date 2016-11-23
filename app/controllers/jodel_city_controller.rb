class JodelCityController < ApplicationController

  @@base_url = "http://www.jodelstats.com"

  def index
    if ENV["jodelstats_error_message"]
      flash.now[:error] = ENV["jodelstats_error_message"]
    end
    if ENV["jodelstats_success_message"]
      flash.now[:success] = ENV["jodelstats_success_message"]
    end
    @jodel_cities = JodelCity.where(country: params[:country_name]).order(highest_votes: :desc)
    redirect_to "/?locale=#{I18n.locale}" and return if @jodel_cities.empty?
    respond_to do |format|
      format.html
      format.json { render json: @jodel_cities, methods: :first_jodel }
    end
  end

  #Tries to load the city. If the city does not exist, tries to do a search.
  #If the city cannot be found, the user is redirected to search.
  def show
    @city = JodelCity.find_by(name: params[:city_name])
    if @city.nil?
      @city = create_city(params[:city_name])
      if @city.nil?
        redirect_to(search_path, {:flash => { :error => I18n.t('error_city_deleted') }}) and return
      end
    end
    if @city.country.nil?
      link = request.base_url + request.fullpath.split("?")[0]
      flash.now[:success] = (I18n.t('banner_link_1') + @city.name + I18n.t('banner_link_2') +
            ActionController::Base.helpers.link_to(link, link)).html_safe
    end

    @jodel_posts = @city.jodel_posts.order(vote_count: :desc)

    respond_to do |format|
      format.html
      format.json { render json: @jodel_posts }
    end
  end

  def new
  end

  #Returns city if it exists in the database
  def city_from_database(name)
    JodelCity.where("lower(name) = ?", name.downcase).first
  end

  #Creates the city and recirects to its page or back to search if the city name was not found.
  def create
    city = create_city(params[:city][:name])
    if city.nil?
      redirect_to "/search?locale=#{I18n.locale}", flash: {error: I18n.t('city_not_found')}
    else
      redirect_to "/cities/#{URI::escape(city.name)}?locale=#{I18n.locale}"
    end
  end

  #Checks if a given city exist in the database and returns the city if it exists
  #If the city is not found, Google Maps is queried.
  #The name Google returns is looked up in the database too. (useful e.g. if
  #the user made a typo)
  #If that also fails, we try to create a new city from Google's data.
  def create_city(name)
    city = city_from_database(name)
    unless city
      @gHandler ||= GoogleHandler.new
      result = @gHandler.coordinates_for(name)

      if !result.nil?
        city = city_from_database(result[:name])
        if city
          return city
        end
        city = JodelCity.create(result)
        api_key = ApiKey.first.token
        handler = JodelHandler.new(api_key)
        JodelCityController.update_city(city)
        return city
      end
    end
  end

  def self.update_cities
    if ApiKey.first.expiration_date < 1.hour.from_now
      self.update_api_token
    end

    cities = JodelCity.all
    cities.each do |city|
      if city.country == nil
        city.destroy
      else
        self.update_city(city)
        sleep((ENV["jodelstats_sleep_seconds"] || 20).to_i)
      end
    end
  end

  def self.update_city(city)
    @api_key = ApiKey.first.token
    handler = JodelHandler.new(@api_key)

    city.jodel_posts.destroy_all
    response = handler.get_posts(city.latitude, city.longitude)
    top_posts = response["voted"]
    if !top_posts.nil? && !top_posts.empty?
      city.update_attributes(highest_votes: top_posts[0]["vote_count"])
    end
    if !top_posts.nil?
      top_posts.each do |post|
        city.jodel_posts.create(post_id: post["id"], created_at: post["created_at"],
              updated_at: post["updated_at"], message: post["message"],
              vote_count: post["vote_count"], color: post["color"],
              image_url: post["image_url"], thumbnail_url: post["thumbnail_url"])
      end
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
