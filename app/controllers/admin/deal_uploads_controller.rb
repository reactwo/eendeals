class Admin::DealUploadsController < ApplicationController

  layout 'admin'

  before_action :set_deal_upload, only: [:show, :approve, :decline, :destroy]

  def index
    respond_to do |format|
      format.html
      format.json { render json: DealUploadDatatable.new(view_context) }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.js
    end
  end

  def approve
    Deal.transaction do
      @deal_upload.status = true
      if @deal_upload.save
        flash[:success] = 'Deal upload approved'
        @status = true
        t = Transaction.new
        t.amount = @deal_upload.deal.amount
        t.category = Transaction::CATEGORY[:deal]
        t.direction = Transaction::DIRECTION[:credit]
        t.user = @deal_upload.user
        t.from_user = @deal_upload.user
        t.from_user_status = @deal_upload.user.status

        t.save!

        @deal_upload.user.wallet.add_money t.amount
      else
        flash[:error] = 'There was some error'
        @status = false
      end
      respond_to do |format|
        format.html { redirect_to admin_deal_upload_path(@deal_upload) }
        format.js
      end
    end
  end

  def decline
    @deal_upload.status = false
    if @deal_upload.save
      flash[:success] = 'Deal upload declined'
      @status = true
    else
      flash[:error] = 'There was some error'
      @status = false
    end
    respond_to do |format|
      format.html { redirect_to admin_deal_upload_path(@deal_upload) }
      format.js
    end
  end

  def destroy
    if @deal_upload.destroy
      flash[:success] = 'Deal upload destroyed'
      redirect_to admin_deal_uploads_path
    else
      flash[:error] = 'There was some error'
      redirect_to admin_deal_upload_path(@deal_upload)
    end
  end

  private

  def set_deal_upload
    @deal_upload = DealUpload.find_by_id params[:id]
  end

end
