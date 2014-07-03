class AddNumberToRoutes < ActiveRecord::Migration
  def change
    add_column :routes, :number, :string
  end
end
