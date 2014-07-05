json.(@user_route, :direction)
json.route do |json|
  json.(@user_route.route, :name)
end
json.stop do |json|
  json.(@user_route.start_stop, :stop_code)
end