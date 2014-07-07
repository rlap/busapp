class AddImageFileToAudioClips < ActiveRecord::Migration
  def change
    add_column :audio_clips, :image_file, :string
    rename_column :audio_clips, :file, :audio_file
  end
end
