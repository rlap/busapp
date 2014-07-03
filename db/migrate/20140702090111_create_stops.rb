class CreateStops < ActiveRecord::Migration
  def change
    create_table :stops do |t|
      t.string :stop_code
      t.string :stop_name
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
