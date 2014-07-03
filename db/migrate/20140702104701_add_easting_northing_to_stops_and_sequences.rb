class AddEastingNorthingToStopsAndSequences < ActiveRecord::Migration
  def change
    add_column :stops, :easting, :integer
    add_column :stops, :northing, :integer
    add_column :route_sequences, :northing, :integer
    add_column :route_sequences, :easting, :integer
  end
end
