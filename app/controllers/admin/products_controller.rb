class Admin::ProductsController < ApplicationController

  layout 'admin'

  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html
      format.json { render json: ProductDatatable.new(view_context) }
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new product_params
    if @product.save
      flash[:success] = 'Product Added'
      redirect_to admin_products_path
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @product.update! product_params
      flash[:success] = 'Product Updated'
      redirect_to admin_product_path @product
    else
      flash[:error] = 'Please try again'
      render 'edit'
    end
  end

  def destroy
    if @product.destroy
      flash[:error] = 'Product deleted'
      redirect_to admin_products_path
    else
      flash[:error] = 'Please try again'
      redirect_back fallback_location: admin_products_path
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :image, :price, :description, :link, :active, :slug, :amount)
  end

  def set_product
    @product = Product.find_by_id params[:id]
  end

end
