class AudioClip < ActiveRecord::Base
  belongs_to :route
  has_many :user_routes, class_name: "UserRoute", :foreign_key => "current_clip_id"
  geocoded_by :address
  after_validation :geocode

  # reverse_geocoded_by :latitude, :longitude
end
