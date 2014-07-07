class UserRoutesController < ApplicationController
  before_filter :authenticate_user!
  
  def start_tour_info
    @user_route = current_user.user_routes.where(current: true).order(created_at: :desc).first
  end

  def set_current_clip
    @user_route = current_user.user_routes.where(current: true).order(created_at: :desc).first
    @user_route.current_clip_id = params[:current_clip_id]
    respond_to do |format|
      if @user_route.save
        format.json { render json: current_user, status: :ok }
      else
        format.json { render json: current_user.errors, status: :unprocessable_entity }
      end
    end
  end

end