class AudioClip < ActiveRecord::Base
  belongs_to :route
  has_many :user_routes, class_name: "UserRoute", :foreign_key => "current_clip_id"
  geocoded_by :address
  after_validation :geocode

  # reverse_geocoded_by :latitude, :longitude

  def stops_before(current_user, audio)
    user_route = current_user.user_routes.where(current: true).order(created_at: :desc).first
    direction = user_route.direction
    route_name = user_route.route.name
    route_id = user_route.route.id

    if east_or_west(route_name, direction) == :east_sequence
      if AudioClip.where(route_id: route_id).minimum(:east_sequence) == east_sequence
        previous_clip_sequence = 0
      else
        previous_clip_sequence = AudioClip.where("east_sequence < ?", east_sequence).order(east_sequence: :desc).first.east_sequence
      end
      RouteSequence.where(route_id: route_id, direction: direction).where("east_sequence < ?", east_sequence).where("east_sequence > ?", previous_clip_sequence)
    else 
      if AudioClip.where(route_id: route_id).minimum(:west_sequence) == west_sequence
        previous_clip_sequence = 0
      else
        previous_clip_sequence = AudioClip.where("west_sequence < ?", west_sequence).order(west_sequence: :desc).first.west_sequence
      end
      RouteSequence.where(route_id: route_id, direction: direction).where("west_sequence < ?", west_sequence).where("west_sequence > ?", previous_clip_sequence)
    end
  end

  def east_or_west(route_name, direction)
    if (Route::WEST_EAST_START1.include? route_name) && (direction == 1)
      :east_sequence
    elsif (Route::WEST_EAST_START1.include? route_name) && (direction == 2)
      :west_sequence
    elsif (Route::EAST_WEST_START1.include? route_name) && (direction == 1)
      :west_sequence
    elsif (Route::EAST_WEST_START1.include? route_name) && (direction == 2)
      :east_sequence
    else
      puts "ERROR"
    end
  end
end
