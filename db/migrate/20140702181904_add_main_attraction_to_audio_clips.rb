class AddMainAttractionToAudioClips < ActiveRecord::Migration
  def change
    add_column :audio_clips, :main_attraction, :boolean
  end
end
