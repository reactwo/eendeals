class Admin::CategoriesController < ApplicationController

  layout 'admin'

  before_action :set_category, only: [:edit, :destroy, :update]

  def index
    respond_to do |format|
      format.html
      format.json { render json: CategoryDatatable.new(view_context) }
    end
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      redirect_to admin_categories_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @category.update category_params
      redirect_to admin_categories_path
    else
      render 'edit'
    end
  end

  def destroy
    if @category.destroy
      flash[:success] = 'Category removed'
      redirect_to admin_categories_path
    else
      flash[:error] = 'There was some error'
      redirect_back fallback_location: admin_categories_path
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :image, :rewarded_id, :interstitial_id, :rewarded_id, :task_id, :banner_id)
  end

  def set_category
    @category = Category.find_by_id params[:id]
  end
end
