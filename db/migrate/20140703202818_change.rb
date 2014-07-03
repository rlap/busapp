class Change < ActiveRecord::Migration
  def change
    rename_column :user_routes, :start_stop, :start_stop_id
  end
end
