class CreateUserRoutes < ActiveRecord::Migration
  def change
    create_table :user_routes do |t|
      t.references :user, index: true
      t.references :route, index: true
      t.integer :direction
      t.string :start_stop
      t.boolean :current

      t.timestamps
    end
  end
end
