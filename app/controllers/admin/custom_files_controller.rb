class Admin::CustomFilesController < ApplicationController
  layout 'admin'

  before_action :set_custom_file, only: :destroy

  def index
    respond_to do |format|
      format.html
      format.json { render json: CustomFileDatatable.new(view_context) }
    end
  end

  def new
    @custom_file = CustomFile.new
  end

  def create
    @custom_file = CustomFile.new(custom_file_params)

    respond_to do |format|
      if @custom_file.save
        format.html { redirect_to admin_custom_files_path, notice: 'Custom file was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @custom_file.destroy
    respond_to do |format|
      format.html { redirect_to admin_custom_files_path, notice: 'Custom file was successfully destroyed.' }
    end
  end

  private
  def set_custom_file
    @custom_file = CustomFile.find(params[:id])
  end

  def custom_file_params
    params.require(:custom_file).permit(:file, :name)
  end
end
