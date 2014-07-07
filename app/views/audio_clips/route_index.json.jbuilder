json.array!(@audio_clips) do |audio_clip|
  json.extract! audio_clip, :id, :name, :file, :longitude, :latitude
end
