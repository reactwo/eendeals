class Api::V1::DealUploadsController < Api::BaseController

  def create
    deal = DealUpload.new(deal_upload_params)
    deal.user = current_user
    deal.deal_id = params[:id]
    if deal.save
      render json: { status: 1, message: 'Deal image uploaded' }
    else
      render json: { status: 0, message: 'There was some error, please try again in some time' }
    end
  end

  private

  def deal_upload_params
    params.require(:deal_upload).permit(:image)
  end

end