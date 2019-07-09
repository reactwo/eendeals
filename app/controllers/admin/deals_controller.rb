class Admin::DealsController < ApplicationController

  layout 'admin'

  before_action :set_deal, only: [:edit, :show, :update, :destroy]

  def index
    respond_to do |format|
      format.html
      format.json { render json: DealDatatable.new(view_context) }
    end
  end

  def new
    @deal = Deal.new
  end

  def create
    @deal = Deal.new deal_params
    if @deal.save
      flash[:success] = 'Deal saved'
      redirect_to admin_deals_path
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @deal.update! deal_params
      flash[:success] = 'Deal updated'
      redirect_to admin_deal_path(@deal)
    else
      flash[:error] = 'Please try again'
      render 'edit'
    end
  end

  def destroy
    if @deal.destroy
      flash[:error] = 'Deal destroyed'
      redirect_to admin_deals_path
    else
      flash[:error] = 'Please try again'
      redirect_back fallback_location: admin_deal_path(@deal)
    end
  end

  private

  def deal_params
    params.require(:deal).permit(:company_id, :link, :logo, :name, :instructions, :amount, :active, :cap, :reward_later)
  end

  def set_deal
    @deal = Deal.find_by_id params[:id]
  end

end
