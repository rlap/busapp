class RouteSequencesController < ApplicationController
  # NOT NEEDED
  def index
    @route_sequences_11 = RouteSequence.where(direction: 1, route_name: "11")
  end

  def show
    @route_sequences = RouteSequence.where(route_id: params[:id], direction:1).order(:sequence)
  end

  def tour
    user_route = current_user.user_routes.where(current: true).order(created_at: :desc).first
    route_id = user_route.route_id
    direction = user_route.direction
    @route_sequences = RouteSequence.where(route_id: route_id, direction: direction)
  end
end