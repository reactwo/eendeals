class Admin::OffersController < ApplicationController

  layout 'admin'

  before_action :set_offer, only: [:edit, :show, :update, :destroy]

  def index
    respond_to do |format|
      format.html
      format.json { render json: OfferDatatable.new(view_context) }
    end
  end

  def new
    @offer = Offer.new
  end

  def create
    @offer = Offer.new offer_params
    if @offer.save
      flash[:success] = 'Offer saved'
      redirect_to admin_offers_path
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @offer.update! offer_params
      flash[:success] = 'Product updated'
      redirect_to admin_offer_path(@offer)
    else
      flash[:error] = 'Please try again'
      render 'edit'
    end
  end

  def destroy
    if @offer.destroy
      flash[:error] = 'Offer destroyed'
      redirect_to admin_offers_path
    else
      flash[:error] = 'Please try again'
      redirect_back fallback_location: admin_offer_path(@offer)
    end
  end

  def progress

  end

  private

  def offer_params
    params.require(:offer).permit(:company_id, :link, :logo, :name, :instructions, :amount, :active, :reward_later, :cap)
  end

  def set_offer
    @offer = Offer.find_by_id params[:id]
  end
end
