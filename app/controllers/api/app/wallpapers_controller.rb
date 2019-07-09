class Api::App::WallpapersController < Api::AppController

  def show
    wallpaper = Wallpaper.find_by_id params[:id]
    render json: wallpaper
  end

end
