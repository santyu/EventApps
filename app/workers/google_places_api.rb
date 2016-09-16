# -*- coding: utf-8 -*-
require 'google_places'

module GooglePlacesAPI
  
  def self.search_facility_location search_word
    client = GooglePlaces::Client.new("") # API KEYを利用
    place  = client.spots_by_query(search_word).first
    { name: place.name, lat: place.lat, lng: place.lng }
  end
end
