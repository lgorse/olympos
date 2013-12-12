module SearchHelper

  def set_coordinates(zip, country)
    if zip && country
      coordinates = Geocoder.coordinates("#{zip} #{country}")
      @lat = coordinates.first
      @long = coordinates.last
      @zip  = zip
      @country = country
    elsif @current_user.lat && @current_user.long
      @lat = @current_user.lat
      @long = @current_user.long
      get_zip_and_country_from_lat_long(@lat, @long)
    else
      request_location = request.location
      @lat = request_location.latitude
      @long = request_location.longitude
      get_zip_and_country_from_lat_long(@lat, @long)
    end
  end

  def recommended_players(distance)
    if distance
      User.near([@lat, @long], distance).without_user(@current_user)
    else
      User.near([@lat, @long], 20).without_user(@current_user)
    end
  end

  def get_zip_and_country_from_lat_long(lat, long)
    geocode_object = Geocoder.search([@lat,@long]).first
    @zip = geocode_object.postal_code
    @country = geocode_object.country_code
  end

  def organize_unique_players_from_nearby_users(nearby_users)
    @uniques = nearby_users.map{|user| {zip: user.zip, lat: user.lat, long: user.long} }.uniq
    @uniques.each do |unique|
      user_array = nearby_users.select{|user| user.zip == unique[:zip]}.map(&:id)
      unique[:users] = user_array
    end
    build_markers_from_uniques(@uniques)
  end

  def build_markers_from_uniques(uniques)
  	@hash = Gmaps4rails.build_markers(uniques) do |zip, marker|
      marker.lat zip[:lat]
      marker.lng zip[:long]
      marker.json({:users => zip[:users], :zip => zip[:zip] })
      marker.title zip[:users].count.to_s
    end
  end

end
