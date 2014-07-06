class RouteSequencesController < ApplicationController
  def index
    @route_sequences_11 = RouteSequence.where(direction: 1, route_name: "11")
  end

  def show
  end
end