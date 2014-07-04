class AudioClip < ActiveRecord::Base
  belongs_to :route
  geocoded_by :address
  after_validation :geocode

  # reverse_geocoded_by :latitude, :longitude
end
