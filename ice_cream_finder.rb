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
output_type = "json"


geocoding_url = Addressable::URI.new(
  :scheme => "https",
  :host => "maps.googleapis.com",
  :path => "/maps/api/geocode/#{output_type}",
  :query_values => { :address => "1061 Market St, San Francisco, CA", :sensor => false }
).to_s

#Launchy.open(geocoding_url)

location = JSON.parse(RestClient.get(geocoding_url))
coordinates = location["results"].first["geometry"]["location"].values

location = coordinates.join(',')
radius = 10000
types = "food|restaurant"
name = "ice cream"
keywords = "ice cream"
key = "AIzaSyB0PuvFIBx2A1HVQ2PiQPQxC41yhuBfkGI"
rankby = "distance"


places_url = Addressable::URI.new(
  :scheme => "https",
  :host => "maps.googleapis.com",
  :path => "/maps/api/place/nearbysearch/#{output_type}",
  :query_values => { :location => location, :types => types, :sensor => false, :keywords => keywords, :key => key, :rankby => rankby }
).to_s

p places_url
json_results = Launchy.open(places_url)
