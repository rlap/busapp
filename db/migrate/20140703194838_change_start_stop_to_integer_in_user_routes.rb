class ChangeStartStopToIntegerInUserRoutes < ActiveRecord::Migration
  def change
    change_column :user_routes, :start_stop, :integer
  end
end
