class Stop < ActiveRecord::Base
  has_many :route_sequences
  has_many :routes, through: :route_sequences
end
