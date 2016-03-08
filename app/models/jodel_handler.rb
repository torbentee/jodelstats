class JodelHandler
  include HTTParty

  base_uri 'https://api.go-tellm.com/api/v2'

  def initialize(api_key)
    @api_key = api_key
  end

  def get_posts(latitude, longitude)
    puts "/posts/location/combo?lat=#{latitude}&lng=#{longitude}&access_token=#{@api_key}&"
    self.class.get("/posts/location/combo?lat=#{latitude}&lng=#{longitude}&access_token=#{@api_key}&")
  end

  def loudest_post(latitude, longitude)
    response = get_posts(latitude, longitude)
    response["voted"][0]
  end

end
