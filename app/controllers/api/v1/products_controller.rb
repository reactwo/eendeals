class Api::V1::ProductsController < Api::BaseController

  def index
    render json: Product.where(active: true).paginate(per_page: 9, page: params[:page])
  end

end
