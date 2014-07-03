class AddDescriptionToRoutes < ActiveRecord::Migration
  def change
    add_column :routes, :description, :string
  end
end
