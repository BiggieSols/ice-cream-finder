require 'rest-client'
require 'json'
require 'addressable/uri'
require 'launchy'

# need to
# get API key
# figure out lat/long at AA
#
# use
# keyword: ice cream
# type: food, restaurant
#
# https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=500&types=food&name=harbour&sensor=false&key=AddYourOwnKeyHere

#http://maps.googleapis.com/maps/api/geocode/output?parameters

def get_addressable_uri(api, params)
  output_type = "json"
  Addressable::URI.new(
      :scheme => "https",
      :host => "maps.googleapis.com",
      :path => "/maps/api/#{api}/#{output_type}",
      :query_values => params
    ).to_s

end

def current_coordinates
  output_type = "json"
  api = "geocode"
  params = { :address => "1061 Market St, San Francisco, CA",
             :sensor => false }

  geocoding_url = get_addressable_uri(api, params)
  #Launchy.open(geocoding_url)

  location = JSON.parse(RestClient.get(geocoding_url))
  location["results"].first["geometry"]["location"].values.join(",")
end

def nearby_ice_cream_coordinates
  key = "AIzaSyB0PuvFIBx2A1HVQ2PiQPQxC41yhuBfkGI"
  api = "place/nearbysearch"
  params = { :location => current_coordinates,
             :types => "food|restaurant",
             :sensor => false,
             :keywords => "ice cream",
             :key => key,
             :rankby => "distance" }

  places_url = get_addressable_uri(api, params)
  nearby_ice_cream_locations = JSON.parse(RestClient.get(places_url))['results']
  # json_results = Launchy.open(places_url)
end

def ice_cream_shop_addresses
  current_location = current_coordinates

  nearby_ice_cream_coordinates.each do |result|
    new_coords = result["geometry"]["location"].values.join(",")
    get_directions(current_location, new_coords)

  end
end

def get_directions(coords1, coords2)
  api ="directions"
  params = { sensor: false,
             origin: coords1,
             destination: coords2,
             mode: "walking" }

  directions_url = get_addressable_uri(api, params)

  directions = JSON.parse(RestClient.get(directions_url))['routes'].each do |route|
    route["legs"].each do |leg|
      puts "starting at #{leg["start_address"]}"
      puts "ending at #{leg["end_address"]}"
      print "directions: "
      leg["steps"].each do |step|
        p step["html_instructions"]
      end
    end
  end
  puts "\n\n\n"
end

ice_cream_shop_addresses



