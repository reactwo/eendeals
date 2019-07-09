class Api::V1::SettingsController < Api::BaseController

  def index
    render json: Setting.all
  end

  def game
    render json: Setting.where('name IN ("game_minutes", "game_coins")')
  end

end
