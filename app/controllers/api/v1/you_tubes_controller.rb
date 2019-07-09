class Api::V1::YouTubesController < Api::BaseController

  def index
    render json: YouTube.all
  end

end