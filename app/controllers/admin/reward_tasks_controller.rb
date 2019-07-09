class Admin::RewardTasksController < ApplicationController

  layout 'admin'

  def index
    respond_to do |format|
      format.html
      format.json { render json: RewardTaskDatatable.new(view_context) }
    end
  end

end
