class Admin::YouTubesController < ApplicationController

  layout 'admin'

  before_action :set_you_tube, only: [:show, :edit, :update, :destroy]

  # GET /you_tubes
  # GET /you_tubes.json
  def index
    respond_to do |format|
      format.html
      format.json { render json: YouTubeDatatable.new(view_context) }
    end
  end

  # GET /you_tubes/1
  # GET /you_tubes/1.json
  def show
  end

  # GET /you_tubes/new
  def new
    @you_tube = YouTube.new
  end

  # GET /you_tubes/1/edit
  def edit
  end

  # POST /you_tubes
  # POST /you_tubes.json
  def create
    @you_tube = YouTube.new(you_tube_params)

    respond_to do |format|
      if @you_tube.save
        format.html { redirect_to admin_you_tubes_path, notice: 'YouTube was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /you_tubes/1
  # PATCH/PUT /you_tubes/1.json
  def update
    respond_to do |format|
      if @you_tube.update(you_tube_params)
        format.html { redirect_to admin_you_tubes_path, notice: 'YouTube was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /you_tubes/1
  # DELETE /you_tubes/1.json
  def destroy
    @you_tube.destroy
    respond_to do |format|
      format.html { redirect_to admin_you_tubes_url, notice: 'You tube was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_you_tube
      @you_tube = YouTube.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def you_tube_params
      params.require(:you_tube).permit(:link, :name)
    end
end
