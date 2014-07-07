json.array!(@audio_clips) do |audio_clip|
  json.extract! audio_clip, :id, :name, :image_file, :audio_file, :longitude, :latitude
end
