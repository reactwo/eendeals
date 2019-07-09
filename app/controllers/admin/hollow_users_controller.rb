class Admin::HollowUsersController < ApplicationController

  layout 'admin'

  def index
    respond_to do |format|
      format.html
      format.json { render json: OldUserDatatable.new(view_context) }
    end
  end

end