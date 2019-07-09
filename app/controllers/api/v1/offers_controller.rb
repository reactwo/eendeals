class Api::V1::OffersController < Api::BaseController

  def index
    render json: Offer.where(active: true).order(id: :desc).paginate(per_page: 9, page: params[:page])
  end

end
