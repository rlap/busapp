class AddWestSequenceAndEastSequenceToAudioClips < ActiveRecord::Migration
  def change
    add_column :audio_clips, :east_sequence, :float
    add_column :audio_clips, :west_sequence, :float
  end
end
