class CreateRouteSequences < ActiveRecord::Migration
  def change
    create_table :route_sequences do |t|
      t.references :stop, index: true
      t.references :route, index: true
      t.string :route_name
      t.integer :direction
      t.integer :sequence
      t.float :east_sequence
      t.float :west_sequence
      t.integer :stop_code
      t.string :stop_name
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
