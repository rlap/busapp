class Route < ActiveRecord::Base
  has_many :audio_clips
  has_many :user_routes
  has_many :route_sequences
  has_many :stops, through: :route_sequences
  has_many :users, through: :user_routes
  
  WEST_EAST_START1 = ["11", "14", "RV1", "139"]
  EAST_WEST_START1 = ["15", "9", "274"]

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
