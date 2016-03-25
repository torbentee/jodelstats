class GoogleHandler
  include HTTParty
  @@api_key = ENV["GOOGLE_API_KEY"]
  @@base_uri = "https://maps.googleapis.com/maps/api/geocode/json?"

  def coordinates_for(address)
    response = self.class.get(@@base_uri + "address=#{URI::escape(address)}&key=#{@@api_key}")
    if response["status"] != "OK"
      nil
    else
      result = response["results"][0]
      {
        name: result["address_components"][0]["long_name"],
        latitude: result["geometry"]["location"]["lat"],
        longitude: result["geometry"]["location"]["lng"],
        country: nil
      }
    end
  end

end
