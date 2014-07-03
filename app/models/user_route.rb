class UserRoute < ActiveRecord::Base
  belongs_to :route
  belongs_to :user
  belongs_to :start_stop, class_name: "RouteSequence"
end
