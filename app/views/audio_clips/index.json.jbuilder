json.array!(@audio_clips) do |audio_clip|
  json.extract! audio_clip, :id, :name, :file
  json.url audio_clip_url(audio_clip, format: :json)
end
