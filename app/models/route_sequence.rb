class RouteSequence < ActiveRecord::Base
  belongs_to :route 
  belongs_to :stop
  has_many :user_routes

  reverse_geocoded_by :latitude, :longitude
end
