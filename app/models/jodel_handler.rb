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

  def refresh_token(current_client_id, distinct_id, refresh_token)
    puts current_client_id
    puts distinct_id
    puts refresh_token
    response = self.class.post("/users/refreshToken?access_token=#{@api_key}", {
        :headers => {
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Accept-Language" => "en;q=1, de-US;q=0.9, hr-HR;q=0.8",
          "Accept-Encoding" => "gzip, deflate",
          "User-Agent" => "Jodel/3.9.1 (iPhone; iOS 9.3; Scale/2.00)",
          "X-Client-Type" => "ios_3.9.1"
        },
        :body => {
            current_client_id: current_client_id,
            distinct_id: distinct_id,
            refresh_token: refresh_token
          }.to_json
      })
    puts response
    if response["access_token"].nil?
      puts "ERROR: COULD NOT REFRESH TOKEN"
    else
      ApiKey.first.update_attributes(token: response["access_token"],
        expiration_date: Time.at(response["expiration_date"]).to_datetime)
    end
  end

end
