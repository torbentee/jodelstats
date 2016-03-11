class JodelHandler
  include HTTParty

  base_uri 'https://api.go-tellm.com/api/v2'

  def initialize(api_key)
    @api_key = api_key
  end

  def get_posts(latitude, longitude)
    self.class.get("/posts/location/combo?lat=#{latitude}&lng=#{longitude}&access_token=#{@api_key}&")
  end

  def loudest_post(latitude, longitude)
    response = get_posts(latitude, longitude)
    puts response
    if response["voted"].nil?
      {"vote_count" => 0, "message" => "(Kein Jodel gefunden. Schau in 5 Minuten nochmal vorbei.)"}
    else
      response["voted"][0]
    end
  end

end
