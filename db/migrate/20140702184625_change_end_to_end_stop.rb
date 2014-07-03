class ChangeEndToEndStop < ActiveRecord::Migration
  def change
    rename_column :routes, :start, :start_stop
    rename_column :routes, :end, :end_stop
  end
end
