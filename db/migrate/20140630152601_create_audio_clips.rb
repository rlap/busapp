class CreateAudioClips < ActiveRecord::Migration
  def change
    create_table :audio_clips do |t|
      t.string :name
      t.text :file

      t.timestamps
    end
  end
end
