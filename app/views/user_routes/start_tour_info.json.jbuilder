json.(@user_route, :direction, :current_clip_id)
json.route do |json|
  json.(@user_route.route, :name)
end
json.stop do |json|
  json.(@user_route.start_stop, :stop_code, :latitude, :longitude, :stop_name)
end