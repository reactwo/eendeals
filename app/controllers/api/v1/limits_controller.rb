class Api::V1::LimitsController < Api::BaseController

  def index
    render json: get_limit
  end

end
