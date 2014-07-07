class UserRoutesController < ApplicationController
  def start_tour_info
    @user_route = current_user.user_routes.where(current: true).order(created_at: :desc).first
  end
end