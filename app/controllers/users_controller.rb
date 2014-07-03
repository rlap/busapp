class UsersController < Devise::RegistrationsController

  before_action :authenticate_user!, only: [:set_location]

  def set_location
    current_user.longitude = params[:longitude] 
    current_user.latitude = params[:latitude] 
    respond_to do |format|
      if current_user.save
        format.json { render json: current_user, status: :ok }
      else
        format.json { render json: current_user.errors, status: :unprocessable_entity }
      end
    end
  end
end