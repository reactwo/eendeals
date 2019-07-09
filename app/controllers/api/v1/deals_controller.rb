class Api::V1::DealsController < Api::BaseController

  def index
    render json: Deal.where(active: true).order(id: :desc).paginate(per_page: 9, page: params[:page])
  end

end
