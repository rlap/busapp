class AddLongitudeLatitudeAddresstoAudioClips < ActiveRecord::Migration
  def change
    add_column :audio_clips, :longitude, :float
    add_column :audio_clips, :latitude, :float
    add_column :audio_clips, :address, :string
  end
end
