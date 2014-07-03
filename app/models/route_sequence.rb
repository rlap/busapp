class RouteSequence < ActiveRecord::Base
  belongs_to :route 
  belongs_to :stop

  reverse_geocoded_by :latitude, :longitude
end
