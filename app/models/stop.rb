class Stop < ActiveRecord::Base
  has_many :route_sequences
  has_many :user_routes, class_name: "UserRoute", :foreign_key => "start_stop_id"
  has_many :routes, through: :route_sequences
end
