json.array!(@route_sequences) do |route_sequence|
  json.extract! route_sequence, :latitude, :longitude
end