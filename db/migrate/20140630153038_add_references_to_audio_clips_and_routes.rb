class AddReferencesToAudioClipsAndRoutes < ActiveRecord::Migration
  def change
    add_column :audio_clips, :route_id, :integer
    add_index :audio_clips, :route_id
  end
end
