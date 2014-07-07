class AddCurrentClipIdToUserRoutes < ActiveRecord::Migration
  def change
    add_column :user_routes, :current_clip_id, :integer
  end
end
