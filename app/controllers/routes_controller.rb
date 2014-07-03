class RoutesController < ApplicationController
  before_action :set_route, only: [:show, :edit, :update, :destroy]

  # GET /routes/1/selection
  def selection
    @route = Route.find(params[:id])
    @user_route = @route.user_routes.build
  end

  # POST /routes/1/selection
  def create_user_route
    @route = Route.find(params[:id])
    @route.user_routes.build(
      user_id: params[:user_id],
      direction: params[:direction],
  # Need to write a new method to find correct stop - closest to me now + others
      start_stop: params[:start_stop],
      current: true
      )
    @route.save

    redirect_to route_directions_path(@route)
  end

  def directions
    binding.pry
    @route = Route.find(params[:id])
    direction = current_user.user_routes.where(current: true).first.direction
    @tour_stops = @route.route_sequences.where(direction: direction)
    @closest_stop = @tour_stops.near([51.5179925229418, -0.0825960236590745], 10)
  end
  
  # GET /routes
  # GET /routes.json
  def index
    @routes = Route.all
  end

  # GET /routes/1
  # GET /routes/1.json
  def show
  end

  # GET /routes/new
  def new
    @route = Route.new
  end

  # GET /routes/1/edit
  def edit
  end

  # POST /routes
  # POST /routes.json
  def create
    @route = Route.new(route_params)

    respond_to do |format|
      if @route.save
        format.html { redirect_to @route, notice: 'Route was successfully created.' }
        format.json { render action: 'show', status: :created, location: @route }
      else
        format.html { render action: 'new' }
        format.json { render json: @route.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /routes/1
  # PATCH/PUT /routes/1.json
  def update
    respond_to do |format|
      if @route.update(route_params)
        format.html { redirect_to @route, notice: 'Route was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @route.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /routes/1
  # DELETE /routes/1.json
  def destroy
    @route.destroy
    respond_to do |format|
      format.html { redirect_to routes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_route
      @route = Route.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def route_params
      params.require(:route).permit(:name)
    end
end
