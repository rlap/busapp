class AddStartAndEndToRoutes < ActiveRecord::Migration
  def change
    add_column :routes, :start, :string
    add_column :routes, :end, :string
  end
end
