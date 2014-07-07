class AudioClipsController < ApplicationController
  before_action :set_audio_clip, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /audio_clips
  # GET /audio_clips.json
  def index
    route_id = current_user.user_routes.where(current: true).first.route_id
    @audio_clips = AudioClip.where(route_id: route_id)
  end

  # GET /audio_clips/1
  # GET /audio_clips/1.json
  def show
  end

  # GET /audio_clips/new
  def new
    @audio_clip = AudioClip.new
  end

  # GET /audio_clips/1/edit
  def edit
  end

  # POST /audio_clips
  # POST /audio_clips.json
  def create
    @audio_clip = AudioClip.new(audio_clip_params)

    respond_to do |format|
      if @audio_clip.save
        format.html { redirect_to @audio_clip, notice: 'Audio clip was successfully created.' }
        format.json { render action: 'show', status: :created, location: @audio_clip }
      else
        format.html { render action: 'new' }
        format.json { render json: @audio_clip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /audio_clips/1
  # PATCH/PUT /audio_clips/1.json
  def update
    respond_to do |format|
      if @audio_clip.update(audio_clip_params)
        format.html { redirect_to @audio_clip, notice: 'Audio clip was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @audio_clip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /audio_clips/1
  # DELETE /audio_clips/1.json
  def destroy
    @audio_clip.destroy
    respond_to do |format|
      format.html { redirect_to audio_clips_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_audio_clip
      @audio_clip = AudioClip.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def audio_clip_params
      params.require(:audio_clip).permit(:name, :file)
    end
end
