class Admin::WallpapersController < ApplicationController

  layout 'admin'

  before_action :set_wallpaper, only: [:edit, :destroy, :update]

  def index
    respond_to do |format|
      format.html
      format.json { render json: WallpaperDatatable.new(view_context) }
    end
  end

  def new
    @wallpaper = Wallpaper.new
  end

  def create
    @wallpaper = Wallpaper.new wallpaper_params
    if @wallpaper.save
      flash[:success] = 'Wallpaper saved'
      redirect_to admin_wallpapers_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @wallpaper.update wallpaper_params
      flash[:success] = 'Wallpaper updated'
      redirect_to admin_wallpapers_path
    else
      render 'edit'
    end
  end

  def destroy
    if @wallpaper.destroy
      flash[:success] = 'Wallpaper deleted'
      redirect_to admin_wallpapers_path
    else
      redirect_back fallback_location: admin_wallpapers_path
    end
  end

  private

  def wallpaper_params
    params.require(:wallpaper).permit(:name, :image, :premium, :downloaded, :category_id)
  end

  def set_wallpaper
    @wallpaper = Wallpaper.find_by_id params[:id]
  end

end
